extends Control

signal ethnicity_selected
signal ethnicity_cleared

export(ButtonGroup) var trait_group


var ethnicity_list = []
var current_ethnicity_index = 0
var current_ethnicity_data = {}
export var ethnicity_selected = false

onready var picture = $"%EthnicityPic"
onready var ethnicity_name = $"%EthnicityName"
onready var ethnicity_description = $"%EthnicityDescription"
onready var trait_container = $"%TraitContainer"
onready var attribute_bonus_label = $"%AttributeBonus"
onready var attribute_selector = $"%AttributeSelect"

onready var trait_button_scene = preload("res://Scenes/EthnicityPage/EthnicityTrait.tscn")
onready var alternate_trait_button_scene = preload("res://Scenes/EthnicityPage/EthnicityJackOfAllTradesSquaredTrait.tscn")


func _ready() -> void:
	ethnicity_list = DatabaseOperations.read_ethnicity_identifiers()
	current_ethnicity_data = DatabaseOperations.read_data_for_etnicity(ethnicity_list[current_ethnicity_index]["ethnicity_identifier"])
	trait_group = load("res://Scenes/EthnicityPage/Traits.tres")
	_fill_attribute_selector_options()


func load_step() -> void:
	_load_ethnicity(current_ethnicity_data)
	_fill_attribute_bonus_label()


func clean_up_step() -> void:
	DatabaseOperations.update_player_ethnicity(CharacterStats.player_id, "", "")
	if ethnicity_selected:
		emit_signal("ethnicity_cleared")


func _set_image(path) -> void:
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)


func _load_ethnicity(ethnicity) -> void:
	_set_image("res://Resources/EthnicityPage/splash_art/" + ethnicity["splash_art_name"])
	ethnicity_name.text = tr(ethnicity["ethnicity_name"])
	ethnicity_description.bbcode_text = "%s" % tr(ethnicity["ethnicity_description"])
	var trait_list = DatabaseOperations.read_traits_for_ethnicity(ethnicity["ethnicity_identifier"])
	if trait_container.get_child_count() > 0:
		for n in trait_container.get_children():
			trait_container.remove_child(n)
			n.queue_free()
	if len(trait_list) == 2:
		_create_trait_list_filler()
	for trait in trait_list:
		var trait_button: Button
		if trait["trait_identifier"] == "versatility_squared":
			trait_button = _create_trait_button(alternate_trait_button_scene, trait)
			var trait_button_trait_list = trait_button.get_node("%TraitSelectionButton")
			_fill_trait_button_trait_list(
				trait_button_trait_list, 
				DatabaseOperations.read_list_of_ethnicity_traits_without_versatilities())
			trait_button.secondary_trait = trait_button.option_button.get_item_text(0)
		elif trait["trait_identifier"] == "natural_killer":
			trait_button = _create_trait_button(alternate_trait_button_scene, trait)
			var trait_button_trait_list = trait_button.get_node("%TraitSelectionButton")
			var skill_packs = DatabaseOperations.read_packs_for_specialization("warrior")
			var skill_packs_names = []
			for pack in skill_packs:
				skill_packs_names.append(tr(pack["skill_pack_name"]))
			_fill_trait_button_trait_list(
				trait_button_trait_list, 
				skill_packs_names)
		elif trait["trait_identifier"] == "nobly_born":
			trait_button = _create_trait_button(alternate_trait_button_scene, trait)
			var trait_button_trait_list = trait_button.get_node("%TraitSelectionButton")
			var skill_packs = DatabaseOperations.read_all_skill_packs_for_attribute("character_name")
			var skill_packs_names = []
			for pack in skill_packs:
				skill_packs_names.append(tr(pack["skill_pack_name"]))
			_fill_trait_button_trait_list(
				trait_button_trait_list, 
				skill_packs_names)
		else:
			var __ = _create_trait_button(trait_button_scene, trait)
	if len(trait_list) == 2:
		_create_trait_list_filler()

func _create_trait_list_filler() -> void:
		var control = Control.new()
		control.size_flags_horizontal = 3
		control.size_flags_vertical = 3
		control.size_flags_stretch_ratio = 0.5
		trait_container.add_child(control)
	
func _create_trait_button(trait_template, trait_data) -> Button:
	var trait_button = trait_template.instance()
	trait_container.add_child(trait_button)
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_name"])
	trait_button.trait_description_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_description"])
	trait_button.connect("trait_button_pressed",
		self,
		"_on_Trait_Button_button_pressed")
	trait_button.identifier = trait_data["trait_identifier"]
	trait_button.trait_name = tr(trait_data["trait_name"])
	trait_button.description = tr(trait_data["trait_description"])
	trait_button.tooltip_text = tr(trait_data["trait_description"])
	if trait_data["trait_id"]:
		trait_button.trait_id = trait_data["trait_id"]
	trait_button.get_node(".").set_button_group(trait_group)
	return trait_button


func _on_Trait_Button_button_pressed(button) -> void:
	if CharacterStats.is_special_rules_ethnicity_applied():
		for rule in CharacterStats.special_rules["Ethnicity"]:
			rule.undo_perform_special_rule_action()
	var query = DatabaseOperations.get_special_rules_for_trait(button.trait_id)
	var special_rules = DatabaseOperations.create_special_rules_from_database_query_result(query)
	if special_rules:
		for rule in special_rules:
			rule.perform_special_rule_actions(button)
		CharacterStats.special_rules["Ethnicity"] = special_rules
	var bonus_attribute = _get_bonus_attribute()
	CharacterStats._on_EthnicityStep_ethnicity_chosen(current_ethnicity_data)
	CharacterStats._on_EthnicityStep_attribute_chosen(bonus_attribute)
	CharacterStats._on_EthnicityStep_trait_chosen(button)
	ethnicity_selected = true
	emit_signal("ethnicity_selected")
	
func _get_bonus_attribute() -> int:
	if ethnicity_list[current_ethnicity_index]["ethnicity_identifier"] =="none_of_your_fucking_business":
		return attribute_selector.selected
	return current_ethnicity_data["attribute_enum"]
		

func _fill_trait_button_trait_list(trait_list_element: OptionButton, query_result) -> void:
	for trait in query_result:
		trait_list_element.add_item(trait)


func _fill_attribute_bonus_label() -> void:
	if ethnicity_list[current_ethnicity_index]["ethnicity_identifier"] =="none_of_your_fucking_business":
		attribute_bonus_label.visible = false
		attribute_selector.visible = true
		return
	attribute_selector.visible = false
	attribute_bonus_label.visible = true
	attribute_bonus_label.bbcode_text = "[right]%s +1[/right]" % tr(current_ethnicity_data["attribute_name"])

func _on_AttributeSelect_item_selected(index) -> void:
	CharacterStats._on_EthnicityStep_attribute_chosen(index)


func _on_PreviousEthnicity_button_up() -> void:
	if current_ethnicity_index == 0:
		current_ethnicity_index = len(ethnicity_list)-1
	else:
		current_ethnicity_index -= 1
	current_ethnicity_data = DatabaseOperations.read_data_for_etnicity(ethnicity_list[current_ethnicity_index]["ethnicity_identifier"])
	_load_ethnicity(current_ethnicity_data)
	_fill_attribute_bonus_label()
	_changed_ethnicity()

func _on_NextEthnicity_button_up() -> void:
	if current_ethnicity_index == len(ethnicity_list)-1:
		current_ethnicity_index = 0
	else:
		current_ethnicity_index += 1
	current_ethnicity_data = DatabaseOperations.read_data_for_etnicity(ethnicity_list[current_ethnicity_index]["ethnicity_identifier"])
	_load_ethnicity(current_ethnicity_data)
	_fill_attribute_bonus_label()
	_changed_ethnicity()


func _fill_attribute_selector_options() -> void :
	attribute_selector.clear()
	for attribute in DatabaseOperations.read_list_of_attributes_without_any():
		attribute_selector.add_item(tr(attribute))


func _changed_ethnicity() -> void:
	ethnicity_selected = false
	emit_signal("ethnicity_cleared")
	CharacterStats._on_EthnicityStep_clear_ethnicity()
	CharacterStats._on_EthnicityStep_clear_bonus_attribute()

