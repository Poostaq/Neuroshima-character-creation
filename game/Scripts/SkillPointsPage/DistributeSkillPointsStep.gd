extends Control

signal points_spent
signal points_returned

var step_name = "skill_points_step_description"
onready var current_attribute_label = $"%CurrentAttributeLabel"
onready var chosen_spec_label = $"%ChosenSpecLabel"
onready var skill_pack_grid = $"%SkillPackGrid"
onready var current_specialization_amount = $"%CurrentSpecializationAmount"
onready var current_all_amount = $"%CurrentAllAmount"
onready var skillPackScene = preload("res://Scenes/SkillPointsPage/SkillPackContainer.tscn")
onready var generalKnowledgePackScene = preload("res://Scenes/SkillPointsPage/GeneralKnowledgeContainer.tscn")
onready var description_name = $"%DescriptionName"
onready var description_text = $"%DescriptionText"
onready var alternative_general_knowledge = $"%AlternativeGeneralKnowledge"


var skill_packs_data_list_grouped_by_attribute = []
var _current_attribute_index = 0
var _current_attribute_pack_data = {}
var _general_spent_on_general_points = 0
export var selected_options = [0,1,2]

onready var _current_all_skill_points = GlobalVariables.max_skill_points
onready var _current_specialization_skill_points = GlobalVariables.max_specialization_skill_points

func _init() -> void:
	skill_packs_data_list_grouped_by_attribute = DatabaseOperations.read_all_skill_packs_for_all_atributes()

func load_step():
	CharacterStats.duplicate_data(CharacterStats.skill_data, CharacterStats.skill_data_before_skill_distribution)
	DatabaseOperations.update_player_specialization(CharacterStats.player_id, CharacterStats.specialization_identifier)
	_current_all_skill_points = GlobalVariables.max_skill_points
	_current_specialization_skill_points = GlobalVariables.max_specialization_skill_points
	_general_spent_on_general_points = 0
	load_skill_packs_screen_data()

func load_skill_packs_screen_data():
	remove_skill_pack_containers()
	_current_attribute_pack_data = skill_packs_data_list_grouped_by_attribute[_current_attribute_index]
	set_ui_layout()
	
	for skill_pack in _current_attribute_pack_data["skill_packs_data"].keys():
		var skill_pack_id = _current_attribute_pack_data["skill_packs_data"][skill_pack].identifier
		var character_stats_pack_data = CharacterStats.get_pack_data(skill_pack_id,
		CharacterStats.skill_data)
		if character_stats_pack_data.identifier == "general_knowledge":
			if CharacterStats.is_alternative_general_knowledge_active() and _current_attribute_index == 3:
				_fill_alternate_general_knowledge(character_stats_pack_data)
			else:
				_create_skill_pack(character_stats_pack_data, generalKnowledgePackScene)
		else:
			_create_skill_pack(character_stats_pack_data, skillPackScene)
	set_all_skill_packs_button_states()
	update_texts()

func remove_skill_pack_containers():
	for child in skill_pack_grid.get_children():
		child.queue_free()

func set_ui_layout():
	if CharacterStats.is_alternative_general_knowledge_active() and _current_attribute_index == 3:
		skill_pack_grid.columns = 2
		alternative_general_knowledge.visible = true
	else:
		skill_pack_grid.columns = 3
		alternative_general_knowledge.visible = false

func clean_up_step():
	CharacterStats.duplicate_data(CharacterStats.skill_data_before_skill_distribution, CharacterStats.skill_data)
	_current_all_skill_points = GlobalVariables.max_skill_points
	_current_specialization_skill_points = GlobalVariables.max_specialization_skill_points
	_general_spent_on_general_points = 0
	DatabaseOperations.update_player_skill_levels(CharacterStats.player_id, CharacterStats.get_all_skill_dictionary())
	selected_options = [0,1,2]

func _create_skill_pack(skill_pack_data: SkillPack, skill_pack_scene: Resource):
	var skill_pack_instance = skill_pack_scene.instance()
	skill_pack_instance.skill_pack_data = skill_pack_data
	skill_pack_grid.add_child(skill_pack_instance)
	skill_pack_instance.update_texts()
	skill_pack_instance.update_skill_data()
	if skill_pack_instance.skill_pack_data.bought:
		skill_pack_instance.buy_pack_button.visible = false
		skill_pack_instance.sell_pack_button.visible = true
	else:
		skill_pack_instance.buy_pack_button.visible = true
		skill_pack_instance.sell_pack_button.visible = false
	skill_pack_instance.connect("mouse_entered_skill_name_of_skill_pack", self, "_on_SkillPackContainer_mouse_entered_skill_name")
	skill_pack_instance.connect("skill_pack_skill_plus_pressed", self, "on_skill_pack_skill_plus_pressed")
	skill_pack_instance.connect("skill_pack_skill_minus_pressed", self, "on_skill_pack_skill_minus_pressed")
	skill_pack_instance.connect("buy_pack_button_pressed", self, "on_buy_pack_button_pressed")
	skill_pack_instance.connect("sell_pack_button_pressed", self, "on_sell_pack_button_pressed")
	if skill_pack_instance.skill_pack_data.identifier == "general_knowledge":
		skill_pack_instance.connect("general_skill_pack_skill_selected", self, "_on_general_skill_pack_skill_selected")
		refresh_all_general_knowledge_dropdowns(skill_pack_instance)
		

func _fill_alternate_general_knowledge(skill_pack_data: SkillPack):
	alternative_general_knowledge.skill_pack_data = skill_pack_data
	alternative_general_knowledge.update_texts()
	alternative_general_knowledge.update_skill_data()
	if alternative_general_knowledge.skill_pack_data.bought:
		alternative_general_knowledge.buy_pack_button.visible = false
		alternative_general_knowledge.sell_pack_button.visible = true
	else:
		alternative_general_knowledge.buy_pack_button.visible = true
		alternative_general_knowledge.sell_pack_button.visible = false
	set_all_skill_packs_button_states()


func update_texts():
	var current_attribute_label_text = tr("current_attribute_label")
	current_attribute_label.text = current_attribute_label_text % tr(_current_attribute_pack_data["name"])
	var current_specialization_label = tr("current_specialization_label")
	chosen_spec_label.text = current_specialization_label % tr(CharacterStats.specialization)
	current_specialization_amount.text = str(_current_specialization_skill_points)
	current_all_amount.text = str(_current_all_skill_points)


func update_skill_points() -> void:
	current_all_amount.text = "%s" % _current_all_skill_points
	current_specialization_amount.text = "%s" % _current_specialization_skill_points


func on_skill_pack_skill_plus_pressed(skill_pack, skill_object):
	var current_skill_level = skill_object.skill_data.level
	var spec_name = skill_pack.skill_pack_data.specialization_identifier
	if current_skill_level >= GlobalVariables.max_skill_level:
		return
	if current_skill_level > 0:
		if can_pay(current_skill_level+1, spec_name) == false:
			return
		pay_points(current_skill_level+1, CharacterStats.specialization_identifier in spec_name)
		if can_activate_next_step():
			emit_signal("points_spent")
	if current_skill_level == 0:
		if can_pay(3, spec_name) == false:
			return
		pay_points(3, CharacterStats.specialization_identifier in spec_name)
		if can_activate_next_step():
			emit_signal("points_spent")
	skill_object.skill_data.level += 1
	update_skill_points()
	skill_object.update_text()
	save_pack_data(skill_pack.skill_pack_data)
	set_all_skill_packs_button_states()
	
func on_skill_pack_skill_minus_pressed(skill_pack, skill_object):
	var current_skill_level = skill_object.skill_data.level
	var spec_name = skill_pack.skill_pack_data.specialization_identifier
	if current_skill_level <= 0:
		return
	if current_skill_level > 1:
		return_points(current_skill_level, CharacterStats.specialization_identifier in spec_name)
		emit_signal("points_returned")
	if current_skill_level == 1:
		return_points(3, CharacterStats.specialization_identifier in spec_name)
		emit_signal("points_returned")
	skill_object.skill_data.level -= 1
	skill_object.update_text()
	set_all_skill_packs_button_states()
	update_skill_points()
	save_pack_data(skill_pack.skill_pack_data)

func _on_SkillPackContainer_mouse_entered_skill_name(skill_data: SkillData):
	description_name.text = skill_data.name
	description_text.bbcode_text = tr(skill_data.description)


func can_pay(amount: int, specialization: String):
	if CharacterStats.specialization_identifier in specialization:
		if amount <= _current_specialization_skill_points+_current_all_skill_points:
			return true
		return false
	if amount > _current_all_skill_points:
		return false
	return true

func pay_points(amount:int, is_specialization: bool):
	var remainder = amount-_current_specialization_skill_points
	if is_specialization:
		if remainder <= 0:
			_current_specialization_skill_points -= amount
			return
		_current_specialization_skill_points = 0
		_current_all_skill_points -= remainder
		return
	_current_all_skill_points -= amount
	_general_spent_on_general_points += amount
	return

func return_points(amount:int, is_specialization: bool):
	var spent_general_points = GlobalVariables.max_skill_points - _current_all_skill_points
	var general_on_spec_skill_points = spent_general_points - self._general_spent_on_general_points
	if not is_specialization:
		_current_all_skill_points += amount
		_general_spent_on_general_points -= amount
		return
	# skill from selected specialization and paid from all skills pool
	if general_on_spec_skill_points >= amount:
		_current_all_skill_points += amount
		return
	# not enough points to return to general
	var points_to_spec = amount - general_on_spec_skill_points
	_current_all_skill_points += general_on_spec_skill_points
	_current_specialization_skill_points += points_to_spec
	

func save_pack_data(skill_pack: SkillPack) -> void:
	for key in CharacterStats.skill_data:
		if CharacterStats.skill_data[key].identifier == skill_pack.identifier:
			CharacterStats.skill_data[key] = skill_pack
			return
	
func on_buy_pack_button_pressed(skill_pack_object):
	var spec_name = skill_pack_object.skill_pack_data.specialization_identifier
	var skill_objects = skill_pack_object.skill_object_group.get_children()
	if _is_all_skill_levels_n(skill_objects, 0):
		if can_pay(5, spec_name) == false:
			return
		pay_points(5, CharacterStats.specialization_identifier in spec_name)
		if can_activate_next_step():
			emit_signal("points_spent")
		buy_pack(skill_pack_object)
		update_skill_points()
		save_pack_data(skill_pack_object.skill_pack_data)
		set_all_skill_packs_button_states()

func on_sell_pack_button_pressed(skill_pack_object):
	var spec_name = skill_pack_object.skill_pack_data.specialization_identifier
	var skill_objects = skill_pack_object.skill_object_group.get_children()
	if _is_all_skill_levels_n(skill_objects, 1):
		emit_signal("points_returned")
		return_points(5, CharacterStats.specialization_identifier in spec_name)
		update_skill_points()
		sell_pack(skill_pack_object)
		save_pack_data(skill_pack_object.skill_pack_data)
		set_all_skill_packs_button_states()

func _is_all_skill_levels_n(skill_list, n) -> bool:
	for skill in skill_list:
		if skill.skill_data.level != n:
			return false
	return true

func buy_pack(skill_pack_object) -> void:
	var skill_objects = skill_pack_object.skill_object_group.get_children()
	for skill in skill_objects:
		skill.skill_data.level += 1
		skill.update_text()
	skill_pack_object.buy_pack_button.visible = false
	skill_pack_object.sell_pack_button.visible = true
	skill_pack_object.skill_pack_data.bought = true

func sell_pack(skill_pack_object) -> void:
	var skill_objects = skill_pack_object.skill_object_group.get_children()
	for skill in skill_objects:
		skill.skill_data.level -= 1
		skill.update_text()
	skill_pack_object.buy_pack_button.visible = true
	skill_pack_object.sell_pack_button.visible = false
	skill_pack_object.skill_pack_data.bought = false


func _on_Previous_pressed():
	if _current_attribute_index == 0:
		_current_attribute_index = skill_packs_data_list_grouped_by_attribute.size() - 1
	else:
		_current_attribute_index -= 1
	load_skill_packs_screen_data()


func _on_Next_pressed():
	if _current_attribute_index == skill_packs_data_list_grouped_by_attribute.size() - 1:
		_current_attribute_index = 0
	else:
		_current_attribute_index += 1
	load_skill_packs_screen_data()


func _on_general_skill_pack_skill_selected(skill_pack, skill, index):
	var retained_level = skill.skill_data.level
	skill.skill_data.duplicate(skill.general_skill_data[index])
	skill.skill_data.level = retained_level
	var character_stats_pack_data = CharacterStats.get_pack_data(
		_current_attribute_pack_data["skill_packs_data"]["general_knowledge"].identifier,
		CharacterStats.skill_data)
	
	var skill_index = get_skill_index_within_skillpack(skill_pack, skill)
	selected_options[skill_index] = index
	skill_packs_data_list_grouped_by_attribute[_current_attribute_index]["skill_packs_data"]["general_knowledge"].skill_data[skill_index] = skill.general_skill_data[index]
	character_stats_pack_data.skill_data[skill_index] = skill.general_skill_data[index]
	refresh_all_general_knowledge_dropdowns(skill_pack)
	
func refresh_all_general_knowledge_dropdowns(skill_pack):
	var skill_data = skill_pack.skill_pack_data.skill_data
	for i in range(0,skill_data.size()):
		var option_button = skill_pack.skill_object_group.get_children()[i].option_button
		option_button.selected = selected_options[i]
		skill_pack.skill_object_group.get_children()[i].refresh_option_states(selected_options)

func get_option_by_text(option_button, text):
	for x in range(0, option_button.get_item_count()):
		if option_button.get_item_text(x) == text:
			return x

func get_skill_index_within_skillpack(skill_pack, skill):
	var skillpack_group = skill_pack.skill_object_group.get_children()
	for index in range(0, len(skillpack_group)):
		if skillpack_group[index] == skill:
			return index

func can_activate_next_step():
	if _current_all_skill_points == 0 and _current_specialization_skill_points == 0:
		return true
	return false


func set_plus_minus_button_state(skill_pack_object):
	var skills = skill_pack_object.skill_object_group.get_children()
	for i in range(0,skills.size()):
		var skill = skills[i]
		if skill.skill_data.level == GlobalVariables.max_skill_level:
			skill.plus.disabled = true
		else:
			if skill.skill_data.level > 0 and \
			!can_pay(
				skill.skill_data.level+1, skill_pack_object.skill_pack_data.specialization_identifier):
				skill.plus.disabled = true
			elif skill.skill_data.level == 0 \
			and !can_pay(3, skill_pack_object.skill_pack_data.specialization_identifier):
				skill.plus.disabled = true
			else:
				skill.plus.disabled = false
		var pack_data = CharacterStats.get_pack_data(
			skill_pack_object.skill_pack_data.identifier, 
			CharacterStats.skill_data_before_skill_distribution
			)
		var minimal_level = pack_data.skill_data[i].level
		if skill.skill_data.level == minimal_level:
			skill.minus.disabled = true
		elif skill.skill_data.level == 1 and skill_pack_object.skill_pack_data.bought:
			skill.minus.disabled = true
		else:
			skill.minus.disabled = false
			

func set_buy_sell_button_state(skill_pack_object):
	var skills = skill_pack_object.skill_object_group.get_children()
	var spec_name = skill_pack_object.skill_pack_data.specialization_identifier
	if can_pay(5, spec_name) == false:
		skill_pack_object.buy_pack_button.disabled = true
	else:
		if _is_all_skill_levels_n(skills, 0):
			skill_pack_object.buy_pack_button.disabled = false
		else:
			skill_pack_object.buy_pack_button.disabled = true
	if _is_all_skill_levels_n(skills, 1):
		skill_pack_object.sell_pack_button.disabled = false
	else:
		skill_pack_object.sell_pack_button.disabled = true


func set_all_skill_packs_button_states():
	var skill_packs = skill_pack_grid.get_children()
	if CharacterStats.is_alternative_general_knowledge_active() and _current_attribute_index == 3:
		skill_packs.append(alternative_general_knowledge)
	for skill_pack in skill_packs:
		set_plus_minus_button_state(skill_pack)
		set_buy_sell_button_state(skill_pack)
