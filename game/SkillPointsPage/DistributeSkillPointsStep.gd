extends Node


#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export (NodePath) onready var regular_skill_pack_element = get_node(regular_skill_pack_element) as HBoxContainer
export (NodePath) onready var skill_card1 = get_node(skill_card1) as Control
export (NodePath) onready var skill_card2 = get_node(skill_card2) as Control
export (NodePath) onready var skill_card3 = get_node(skill_card3) as Control
export (NodePath) onready var pack_name_label = get_node(pack_name_label) as Label
export (NodePath) onready var skill_description = get_node(skill_description) as RichTextLabel
export (NodePath) onready var skill_name = get_node(skill_name) as Label
export (NodePath) onready var skill_points = get_node(skill_points) as RichTextLabel
export (NodePath) onready var specialization_skill_points = get_node(specialization_skill_points) as RichTextLabel
export (NodePath) onready var skill_pack_indicator = get_node(skill_pack_indicator) as TextureButton
export (NodePath) onready var pack_plus_button = get_node(pack_plus_button) as TextureButton
export (NodePath) onready var pack_minus_button = get_node(pack_minus_button) as TextureButton

export (NodePath) onready var general_knowledge_skill_pack_element = get_node(general_knowledge_skill_pack_element) as HBoxContainer
export (NodePath) onready var general_skill_card1 = get_node(general_skill_card1) as Control
export (NodePath) onready var general_skill_card2 = get_node(general_skill_card2) as Control
export (NodePath) onready var general_skill_card3 = get_node(general_skill_card3) as Control
export (NodePath) onready var general_skill_name = get_node(general_skill_name) as Label
export (NodePath) onready var general_skill_description = get_node(general_skill_description) as RichTextLabel
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _skill_card_list = []
var _skill_packs_list = []
var _general_skill_card_list = []
var _current_skill_card_list = []
var _current_skill_pack_data = {}
var _current_skill_pack_index = 0
var _current_skill_levels = {}
var _initial_skill_levels = {}
var _current_packs = {}
var _initial_packs = {}
var _max_skill_points = 35
var _current_skill_points = 35
var _max_specialization_skill_points = 30
var _current_specialization_skill_points = 30
var _general_spent_on_general_points = 0
var _specialization_id = ""

#####################################
# ONREADY VARIABLES
#####################################

#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass

func load_step():
	_skill_card_list = [skill_card1,skill_card2,skill_card3]
	_general_skill_card_list = [general_skill_card1,general_skill_card2,general_skill_card3]
	_skill_packs_list = DatabaseOperations.read_all_skill_packs()
	_initial_skill_levels = CharacterStats.skill_levels
	_current_skill_levels = _initial_skill_levels
	_specialization_id = CharacterStats.specialization_identifier
	_initial_packs = CharacterStats.skill_packs
	_current_packs = _initial_packs
	_load_package()
	_update_skill_points()


#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################
func _load_package():
	_current_skill_pack_data = _skill_packs_list[_current_skill_pack_index]
	_set_screen_state()
	var skill_pack_id = _current_skill_pack_data["skill_pack_identifier"]
	var pack_data = DatabaseOperations.read_skills_for_package(skill_pack_id)
	var specialization = pack_data[0]["specialization_name"]
	var pack_text = "%s - %s" % [_current_skill_pack_data["skill_pack_name"], specialization]
	pack_name_label.text = pack_text
	if skill_pack_id == "general_knowledge":
		_current_skill_card_list = _general_skill_card_list
		_load_skill_data(_current_skill_card_list, pack_data)
		_load_general_skill_options()
		general_skill_name.text = _current_skill_pack_data["skill_pack_name"]
		general_skill_description.bbcode_text = pack_data[0].skill_description
	else:
		_current_skill_card_list = _skill_card_list
		_load_skill_data(_current_skill_card_list, pack_data)
	skill_pack_indicator.pressed = _is_pack_bought()
	pack_plus_button.disabled = _is_pack_bought()
	pack_minus_button.disabled = not _is_pack_bought()

func _on_NextPack_button_up():
	_current_skill_pack_index += 1
	if _current_skill_pack_index >= len(_skill_packs_list):
		_current_skill_pack_index = 0
	_load_package()
	if _is_pack_bought():
		skill_pack_indicator.pressed = true
	else:
		skill_pack_indicator.pressed = false


func _on_PreviousPack_button_up():
	_current_skill_pack_index -= 1
	if _current_skill_pack_index < 0:
		_current_skill_pack_index = len(_skill_packs_list)-1
	_load_package()
	if _is_pack_bought():
		skill_pack_indicator.pressed = true
	else:
		skill_pack_indicator.pressed = false


func _on_SkillCard_minus_button_pressed(skill):
	skill.emit_signal("button_up")
	skill.pressed = true
	if skill.level <= 0:
		return
	if skill.level > 1:
		_return_points(skill.level)
	if skill.level == 1:
		if _is_pack_bought():
			return
		_return_points(3)
	skill.level -= 1
	skill.update_skill_card_text()
	_update_skill_points()
	_update_skill_levels(skill)


func _on_SkillCard_plus_button_pressed(skill):
	skill.emit_signal("button_up")
	skill.pressed = true
	if skill.level >= 5:
		return
	if skill.level > 0:
		if _pay_points(skill.level+1) == false:
			return
	if skill.level == 0:
		if _pay_points(3) == false:
			return
	skill.level += 1
	skill.update_skill_card_text()
	_update_skill_points()
	_update_skill_levels(skill)


func _on_SkillCard_skill_element_pressed(skill):
	skill_name.text = skill.skill_name
	skill_description.bbcode_text = skill.description


func _update_skill_points():
	var skillpoint_list = [_current_skill_points,_max_skill_points]
	skill_points.bbcode_text = "[center]%s/%s" % skillpoint_list
	var specialization_skillpoint_list = [_current_specialization_skill_points,_max_specialization_skill_points]
	specialization_skill_points.bbcode_text = "[center]%s/%s" % specialization_skillpoint_list


func _update_skill_levels(skill):
	if _current_skill_pack_data["skill_pack_identifier"] == "general_knowledge":
		var option_element = skill.find_node("OptionButton")
		var selected_option_meta = option_element.get_item_metadata(option_element.selected)
		var selected_skill_identifier = selected_option_meta["identifier"]
		_current_skill_levels[selected_skill_identifier] = skill.level
	_current_skill_levels[skill.skill_identifier] = skill.level

func _on_PackMinusButton_button_up():
	if !_current_packs.has(_current_skill_pack_data["skill_pack_identifier"]):
		return
	if !_is_pack_bought():
		return
	var levels = []
	for skill in _current_skill_card_list:
		levels.append(skill.level)
	if _is_all_values_n(levels, 1):
		_sell_pack()
		_update_skill_points()
		for skill in _current_skill_card_list:
			_update_skill_levels(skill)
		pack_plus_button.disabled = false
		pack_minus_button.disabled = true
	


func _on_PackPlusButton_button_up(): 
	if _is_pack_bought():
		return
	var levels = []
	for skill in _current_skill_card_list:
		levels.append(skill.level)
	if _is_all_values_n(levels, 0) and !_is_pack_bought():
		if _pay_points(5) == false:
			return
		_current_packs[_current_skill_pack_data["skill_pack_identifier"]] = true
		_refund_single_skill_buys()
		_buy_pack()
		_update_skill_points()
		for skill in _current_skill_card_list:
			_update_skill_levels(skill)
		pack_plus_button.disabled = true
		pack_minus_button.disabled = false
		


func _is_all_values_n(list, n):
	for value in list:
		if value != n:
			return false
	return true

func _is_any_value_above_n(list, n):
	for value in list:
		if value > n:
			return true
	return false

func _is_all_value_above_n(list, n):
	for value in list:
		if value <= n:
			return false
	return true

func _has_points_to_pay_for_pack_refund(skill):
	if not _specialization_id in skill.specialization:
		if _current_skill_points+5 < 6:
			return false
		return true
	if _current_specialization_skill_points+5 < 6:
		return false
	return true
			

func _buy_pack():
	_current_packs[_current_skill_pack_data["skill_pack_identifier"]] = true
	for skill in _current_skill_card_list:
		skill.level += 1
		skill.update_skill_card_text()
	skill_pack_indicator.pressed = true


func _sell_pack():
	_current_packs[_current_skill_pack_data["skill_pack_identifier"]] = false
	for skill in _current_skill_card_list:
		skill.level -= 1
		skill.update_skill_card_text()
	_return_points(5)
	skill_pack_indicator.pressed = false


func _refund_single_skill_buys():
	var levels = _get_list_of_skill_levels()
	for level in levels:
		if level > 0:
			_return_points(3)


func _pay_points(amount):
	if not _specialization_id in _current_skill_card_list[0].specialization:
		if amount > _current_skill_points:
			return false
		_current_skill_points -= amount
		_general_spent_on_general_points += amount
		return
	if _current_specialization_skill_points-amount < 0:
		var remainder = amount-_current_specialization_skill_points
		if _current_skill_points-remainder < 0:
			return false
		_current_specialization_skill_points = 0
		_current_skill_points -= remainder
		return
	_current_specialization_skill_points-=amount


func _return_points(amount):
	var _spent_spec_points = _max_specialization_skill_points - _current_specialization_skill_points
	var _spent_general_points = _max_skill_points - _current_skill_points
	var _general_on_spec_skill_points = _spent_general_points - _general_spent_on_general_points
	
	if not _specialization_id in _current_skill_card_list[0].specialization:
		_current_skill_points += amount
		_general_spent_on_general_points -= amount
		return
	#_specialization_id == _current_skill_card_list[0].specialization
	if _general_on_spec_skill_points >= amount:
		_current_skill_points += amount
		return
	# _general_on_spec_skill_points < amount:
	var points_to_spec = amount - _general_on_spec_skill_points
	_current_skill_points += _general_on_spec_skill_points
	_current_specialization_skill_points += points_to_spec


func _get_list_of_skill_levels():
	var levels = []
	for skill in _current_skill_card_list:
		levels.append(skill.level)
	return levels


func _is_pack_bought():
	if _current_packs.has(_current_skill_pack_data["skill_pack_identifier"]):
		if _current_packs[_current_skill_pack_data["skill_pack_identifier"]]:
			return true
	return false


func _set_screen_state():
	if _current_skill_pack_data["skill_pack_identifier"] == "general_knowledge":
		regular_skill_pack_element.visible = false
		general_knowledge_skill_pack_element.visible = true
		return
	regular_skill_pack_element.visible = true
	general_knowledge_skill_pack_element.visible = false
	return

func _load_skill_data(skill_card_list, pack_data):
	for index in range(0, len(pack_data)):
		var current_skill_card = skill_card_list[index]
		var skill = pack_data[index]
		current_skill_card.skill_name = skill.skill_name
		current_skill_card.skill_identifier = skill.skill_identifier
		current_skill_card.level = _current_skill_levels[skill.skill_identifier]
		current_skill_card.description = skill.skill_description
		current_skill_card.specialization = skill.specialization_identifier
		current_skill_card.update_skill_card_text()


func _load_general_skill_options():
	var list_of_options = DatabaseOperations.read_general_knowledge_skills()
	var index = 0
	for skill in _general_skill_card_list:
		var option_element = skill.find_node("OptionButton")
		option_element.clear()
		for option_index in range(0, len(list_of_options)):
			option_element.add_item(list_of_options[option_index]["skill_name"], option_index)
			var metadata = {"identifier": list_of_options[option_index]["skill_identifier"]}
			option_element.set_item_metadata(option_index, metadata)
		option_element.select(index)
		option_element.emit_signal("item_selected", index)
		index+=1
		


func _on_OptionButton_item_selected(index):
	refresh_skill_states()
	refresh_current_skill_levels_for_general_knowledge()


func set_skill_inactive(index):
	for skill in _general_skill_card_list:
		var option_element = skill.find_node("OptionButton")
		if option_element.get_item_count() > 0 and index >= 0:
			if option_element.get_selected_id() != index:
				option_element.set_item_disabled(index, true)
			
func clear_disabled_skills():
	for skill in _general_skill_card_list:
		var option_element = skill.find_node("OptionButton")
		for index in range(0, option_element.get_item_count()):
			if option_element.is_item_disabled(index):
				if index != option_element.get_selected_id():
					option_element.set_item_disabled(index, false)
					
func refresh_skill_states():
	clear_disabled_skills()
	var selected_ids = []
	for skill in _general_skill_card_list:
		var option_element = skill.find_node("OptionButton")
		selected_ids.append(option_element.get_selected_id())
	for id in selected_ids:
		set_skill_inactive(id)

func refresh_current_skill_levels_for_general_knowledge():
	var selected_identifiers = []
	for skill in _general_skill_card_list:
		var option_element = skill.find_node("OptionButton")
		print(option_element.get_selected_id())
		if option_element.get_selected_id() >= 0:
			var option_meta = option_element.get_item_metadata(option_element.get_selected_id())
			var selected_identifer = option_meta["identifier"]
			selected_identifiers.append(selected_identifer)
	var list_of_options = DatabaseOperations.read_general_knowledge_skills()
	for option in list_of_options:
		if not option["skill_identifier"] in selected_identifiers:
			if _current_skill_levels.has(option["skill_identifier"]):
				_current_skill_levels.erase(option["skill_identifier"])

