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
export (NodePath) onready var skill_card1 = get_node(skill_card1) as Control
export (NodePath) onready var skill_card2 = get_node(skill_card2) as Control
export (NodePath) onready var skill_card3 = get_node(skill_card3) as Control
export (NodePath) onready var pack_name_label = get_node(pack_name_label) as Label
export (NodePath) onready var skill_description = get_node(skill_description) as RichTextLabel
export (NodePath) onready var skill_name = get_node(skill_name) as Label
export (NodePath) onready var skill_points = get_node(skill_points) as RichTextLabel
export (NodePath) onready var specialization_skill_points = get_node(specialization_skill_points) as RichTextLabel
export (NodePath) onready var skill_pack_indicator = get_node(skill_pack_indicator) as TextureButton
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _skill_card_list = []
var _skill_packs_list = []
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
	var pack_data = DatabaseOperations.read_skills_for_package(_current_skill_pack_data["skill_pack_identifier"])
	pack_name_label.text = _current_skill_pack_data["skill_pack_name"] 
	print(pack_data)
	for index in range(0, len(pack_data)):
		var current_skill_card = _skill_card_list[index]
		var skill = pack_data[index]
		current_skill_card.skill_name = skill["skill_name"]
		current_skill_card.level = _current_skill_levels[skill["skill_identifier"]]
		current_skill_card.description = skill["skill_description"]
		current_skill_card.specialization = skill["specialization_identifier"]
		current_skill_card.update_skill_card_text()
	if _is_pack_bought():
		skill_pack_indicator.pressed = true
		

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


func _on_SkillCard_minus_button_pressed(skill):
	skill.emit_signal("button_up")
	skill.pressed = true
	if skill.level <= 0:
		return
	if skill.level > 1:
		_return_points(skill.level)
	if _is_pack_bought():
		if _pay_points(6) == false:
			return
		_return_points(5)
		_current_packs[_current_skill_pack_data["skill_pack_identifier"]] = false
		skill_pack_indicator.pressed = false
	elif skill.level == 1:
		_return_points(3)
	skill.level -= 1
	skill.update_skill_card_text()
	_update_skill_points()


func _on_SkillCard_plus_button_pressed(skill):
	skill.emit_signal("button_up")
	skill.pressed = true
	if skill.level >= 5:
		return
	if skill.level == 0:
		if _pay_points(3) == false:
			return
	if skill.level > 0:
		if _pay_points(skill.level+1) == false:
			return
	skill.level += 1
	skill.update_skill_card_text()
	_update_skill_points()


func _on_SkillCard_skill_element_pressed(skill):
	skill_name.text = skill.skill_name
	skill_description.bbcode_text = skill.description


func _update_skill_points():
	var skillpoint_list = [_current_skill_points,_max_skill_points]
	skill_points.bbcode_text = "[center]%s/%s" % skillpoint_list
	var specialization_skillpoint_list = [_current_specialization_skill_points,_max_specialization_skill_points]
	specialization_skill_points.bbcode_text = "[center]%s/%s" % specialization_skillpoint_list


func _on_PackMinusButton_button_up():
	if !_current_packs.has(_current_skill_pack_data["skill_pack_identifier"]):
		return
	if !_is_pack_bought():
		return
	_sell_pack()
	_update_skill_points()
	skill_pack_indicator.pressed = false


func _on_PackPlusButton_button_up(): 
	if _is_pack_bought():
		return
	if _pay_points(5) != false:
		_current_packs[_current_skill_pack_data["skill_pack_identifier"]] = true
		print(_current_packs)
		_refund_single_skill_buys()
		_buy_pack()
	_update_skill_points()
	skill_pack_indicator.pressed = true
	


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
	for skill in _skill_card_list:
		if skill.level < 1:
			skill.level += 1
			skill.update_skill_card_text()
	skill_pack_indicator.pressed = true


func _sell_pack():
	_current_packs[_current_skill_pack_data["skill_pack_identifier"]] = false
	for skill in _skill_card_list:
		if skill.level == 1:
			skill.level -= 1
		if skill.level > 1:
			_pay_points(3)
		skill.update_skill_card_text()
	_return_points(5)
	skill_pack_indicator.pressed = false

func _refund_single_skill_buys():
	var levels = _get_list_of_skill_levels()
	for level in levels:
		if level > 0:
			_return_points(3)

func _refund_pack_pay_single_skills():
	_return_points(5)
	var levels = _get_list_of_skill_levels()
	for level in levels:
		if level > 0:
			_pay_points(3)
	

func _pay_points(amount):
	if not _specialization_id in _skill_card_list[0].specialization:
		if amount > _current_skill_points:
			print("ZA MALO PUNKTOW")
			return false
		_current_skill_points -= amount
		return
	if _current_specialization_skill_points-amount < 0:
		var remainder = amount-_current_specialization_skill_points
		if _current_skill_points-remainder < 0:
			print("ZA MALO PUNKTOW")
			return false
		_current_specialization_skill_points = 0
		_current_skill_points -= remainder
		return
	_current_specialization_skill_points-=amount


func _return_points(amount):
	if not _specialization_id in _skill_card_list[0].specialization:
		_current_skill_points += amount
		return
	if _current_specialization_skill_points+amount > _max_specialization_skill_points:
		var remainder = _current_specialization_skill_points+amount-_max_specialization_skill_points
		_current_specialization_skill_points = _max_specialization_skill_points
		_current_skill_points += remainder
		return
	_current_specialization_skill_points+=amount


func _get_list_of_skill_levels():
	var levels = []
	for skill in _skill_card_list:
		levels.append(skill.level)
	return levels

func _is_pack_bought():
	if _current_packs.has(_current_skill_pack_data["skill_pack_identifier"]):
		if _current_packs[_current_skill_pack_data["skill_pack_identifier"]]:
			return true
	return false
