extends Control

signal ethnicity_chosen(current_ethnicity)
signal attribute_chosen(bonus_attribute)
signal trait_chosen(trait_element)
signal clear_trait()


export(ButtonGroup) var trait_group


var ethnicity_list = []
var current_ethnicity = 0
var ethnicity = {}


export (NodePath) onready var picture = get_node(picture) as TextureRect
export (NodePath) onready var ethnicity_name = get_node(ethnicity_name) as RichTextLabel
export (NodePath) onready var ethnicity_description = get_node(ethnicity_description) as RichTextLabel
export (NodePath) onready var trait_container =  get_node(trait_container) as HBoxContainer
export (NodePath) onready var attribute_bonus_label = get_node(attribute_bonus_label) as RichTextLabel
export (NodePath) onready var attribute_selector = get_node(attribute_selector) as OptionButton

onready var trait_button_scene = preload("res://EthnicityPage/EthnicityTrait.tscn")
onready var alternate_trait_button_scene = preload("res://EthnicityPage/EthnicityJackOfAllTradesSquaredTrait.tscn")
onready var db = get_node("/root/DatabaseOperations")


func _ready():
	load_step()
	
	
func load_step():
	ethnicity_list = db.read_ethnicity_identifiers()
	ethnicity = db.read_data_for_etnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"])
	_load_ethnicity(ethnicity)
	_fill_attribute_selector_options()
	_fill_attribute_bonus_label(ethnicity["attribute_name"])
	trait_group = load("res://EthnicityPage/Traits.tres")
	var bonus_attribute = _get_bonus_attribute()
	yield(get_tree(), "idle_frame")
	emit_signal("ethnicity_chosen", ethnicity)
	emit_signal("attribute_chosen", bonus_attribute)
	

func _set_image(path):
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)


func _load_ethnicity(_ethnicity):
	_set_image(ethnicity["splash_art_path"])
	ethnicity_name.bbcode_text = "[center]%s[/center]" % ethnicity["ethnicity_name"]
	ethnicity_description.bbcode_text = "%s" % ethnicity["ethnicity_description"]
	var trait_list = db.read_traits_for_ethnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"])
	if trait_container.get_child_count() > 0:
		for n in trait_container.get_children():
			trait_container.remove_child(n)
			n.queue_free()
	for trait in trait_list:
		if trait["trait_identifier"] == "versatility_squared":
			var trait_button = _create_trait_button(alternate_trait_button_scene, trait)
			var trait_button_trait_list = trait_button.get_node("MarginContainer/VBoxContainer/OptionButton")
			_fill_trait_button_trait_list(trait_button_trait_list)
			trait_button.secondary_trait = trait_button.option_button.get_item_text(0)
		else:
			_create_trait_button(trait_button_scene, trait)


func _create_trait_button(trait_template, trait_data):
	var trait_button = trait_template.instance()
	trait_container.add_child(trait_button)
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % trait_data["trait_name"]
	trait_button.trait_description_label.bbcode_text = "%s" % trait_data["trait_short_description"]
	trait_button.connect("trait_button_pressed",
		self,
		"_on_Trait_Button_button_pressed")
	trait_button.identifier = trait_data["trait_identifier"]
	trait_button.trait_name = trait_data["trait_name"]
	trait_button.description = trait_data["trait_short_description"]
	trait_button.tooltip_text = trait_data["trait_description"]
	trait_button.get_node(".").set_button_group(trait_group)
	return trait_button


func _on_Trait_Button_button_pressed(button):
	emit_signal("trait_chosen", button)

	
func _get_bonus_attribute():
	if ethnicity_list[current_ethnicity]["ethnicity_identifier"] =="none_of_your_fucking_business":
		return attribute_selector.selected
	else:
		return ethnicity["attribute_enum"]
		

func _fill_trait_button_trait_list(trait_list_element: OptionButton):
	for trait in db.read_list_of_ethnicity_traits_without_versatilities():
		trait_list_element.add_item(trait)


func _fill_attribute_bonus_label(_attributes):
	if ethnicity_list[current_ethnicity]["ethnicity_identifier"] =="none_of_your_fucking_business":
		attribute_bonus_label.visible = false
		attribute_selector.visible = true
		return
	attribute_selector.visible = false
	attribute_bonus_label.visible = true
	attribute_bonus_label.bbcode_text = "[right]%s +1[/right]" % ethnicity["attribute_name"]

func _on_AttributeSelect_item_selected(index):
	emit_signal("attribute_chosen", index)


func _on_PreviousEthnicity_button_up():
	if current_ethnicity == 0:
		current_ethnicity = len(ethnicity_list)-1
	else:
		current_ethnicity -= 1
	ethnicity = db.read_data_for_etnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"])
	_load_ethnicity(ethnicity)
	_fill_attribute_bonus_label(ethnicity["attribute_name"])
	_changed_ethnicity()

func _on_NextEthnicity_button_up():
	if current_ethnicity == len(ethnicity_list)-1:
		current_ethnicity = 0
	else:
		current_ethnicity += 1
	ethnicity = db.read_data_for_etnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"])
	_load_ethnicity(ethnicity)
	_fill_attribute_bonus_label(ethnicity["attribute_name"])
	_changed_ethnicity()


func _fill_attribute_selector_options():
	for attribute in db.read_list_of_attributes_without_any():
		attribute_selector.add_item(attribute)


func _changed_ethnicity():
	var bonus_attribute = _get_bonus_attribute()
	emit_signal("ethnicity_chosen", ethnicity)
	emit_signal("attribute_chosen", bonus_attribute)
	emit_signal("clear_trait")
