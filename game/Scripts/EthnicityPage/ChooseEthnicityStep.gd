extends Control

signal ethnicity_selected
signal ethnicity_cleared

export(ButtonGroup) var trait_group


var ethnicity_list = []
var current_ethnicity_index = 0
var current_ethnicity_data = {}
var selected_ethnicity_data = {}


export (NodePath) onready var picture = get_node(picture) as TextureRect
export (NodePath) onready var ethnicity_name = get_node(ethnicity_name) as RichTextLabel
export (NodePath) onready var ethnicity_description = get_node(ethnicity_description) as RichTextLabel
export (NodePath) onready var trait_container =  get_node(trait_container) as HBoxContainer
export (NodePath) onready var attribute_bonus_label = get_node(attribute_bonus_label) as RichTextLabel
export (NodePath) onready var attribute_selector = get_node(attribute_selector) as OptionButton

onready var trait_button_scene = preload("res://Scenes/EthnicityPage/EthnicityTrait.tscn")
onready var alternate_trait_button_scene = preload("res://Scenes/EthnicityPage/EthnicityJackOfAllTradesSquaredTrait.tscn")


func _ready() -> void:
	ethnicity_list = DatabaseOperations.read_ethnicity_identifiers()
	current_ethnicity_data = DatabaseOperations.read_data_for_etnicity(ethnicity_list[current_ethnicity_index]["ethnicity_identifier"])
	trait_group = load("res://Scenes/EthnicityPage/Traits.tres")
	_fill_attribute_selector_options()
	load_step()


func load_step() -> void:
	_load_ethnicity(current_ethnicity_data)
	_fill_attribute_bonus_label()
	yield(get_tree(), "idle_frame")
	_changed_ethnicity()


func clean_up_step() -> void:
	_changed_ethnicity()


func _set_image(path) -> void:
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)


func _load_ethnicity(ethnicity) -> void:
	_set_image("res://Resources/EthnicityPage/splash_art/" + ethnicity["splash_art_name"])
	ethnicity_name.bbcode_text = "[center]%s[/center]" % tr(ethnicity["ethnicity_name"])
	ethnicity_description.bbcode_text = "%s" % tr(ethnicity["ethnicity_description"])
	var trait_list = DatabaseOperations.read_traits_for_ethnicity(ethnicity["ethnicity_identifier"])
	if trait_container.get_child_count() > 0:
		for n in trait_container.get_children():
			trait_container.remove_child(n)
			n.queue_free()
	if len(trait_list) == 2:
		_create_trait_list_filler()
	for trait in trait_list:
		var trait_button: TextureButton
		if trait["trait_identifier"] == "versatility_squared":
			trait_button = _create_trait_button(alternate_trait_button_scene, trait)
			var trait_button_trait_list = trait_button.get_node("HBoxContainer/VBoxContainer/OptionButton")
			_fill_trait_button_trait_list(trait_button_trait_list)
			trait_button.secondary_trait = trait_button.option_button.get_item_text(0)
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
	
func _create_trait_button(trait_template, trait_data) -> TextureButton:
	var trait_button = trait_template.instance()
	trait_container.add_child(trait_button)
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_name"])
	trait_button.trait_description_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_description"])
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_name"])
	trait_button.trait_description_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_description"])
	trait_button.connect("trait_button_pressed",
		self,
		"_on_Trait_Button_button_pressed")
	trait_button.identifier = trait_data["trait_identifier"]
	trait_button.trait_name = tr(trait_data["trait_name"])
	trait_button.description = tr(trait_data["trait_description"])
	trait_button.tooltip_text = tr(trait_data["trait_description"])
	trait_button.trait_name = tr(trait_data["trait_name"])
	trait_button.description = tr(trait_data["trait_description"])
	trait_button.tooltip_text = tr(trait_data["trait_description"])
	trait_button.get_node(".").set_button_group(trait_group)
	return trait_button


func _on_Trait_Button_button_pressed(button) -> void:
	var bonus_attribute = _get_bonus_attribute()
	CharacterStats._on_EthnicityStep_ethnicity_chosen(current_ethnicity_data)
	CharacterStats._on_EthnicityStep_attribute_chosen(bonus_attribute)
	CharacterStats._on_EthnicityStep_trait_chosen(button)
	emit_signal("ethnicity_selected")
	
func _get_bonus_attribute() -> int:
	if ethnicity_list[current_ethnicity_index]["ethnicity_identifier"] =="none_of_your_fucking_business":
		return attribute_selector.selected
	return current_ethnicity_data["attribute_enum"]
		

func _fill_trait_button_trait_list(trait_list_element: OptionButton) -> void:
	for trait in DatabaseOperations.read_list_of_ethnicity_traits_without_versatilities():
		trait_list_element.add_item(trait)


func _fill_attribute_bonus_label() -> void:
	if ethnicity_list[current_ethnicity_index]["ethnicity_identifier"] =="none_of_your_fucking_business":
		attribute_bonus_label.visible = false
		attribute_selector.visible = true
		return
	attribute_selector.visible = false
	attribute_bonus_label.visible = true
	attribute_bonus_label.bbcode_text = "[right]%s +1[/right]" % tr(current_ethnicity_data["attribute_name"])
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
		attribute_selector.add_item(tr(attribute))


func _changed_ethnicity() -> void:
	emit_signal("ethnicity_cleared")
	CharacterStats._on_EthnicityStep_clear_ethnicity()
<<<<<<< HEAD
	CharacterStats._on_EthnicityStep_clear_bonus_attribute()
=======
	CharacterStats._on_EthnicityStep_clear_bonus_attribute()