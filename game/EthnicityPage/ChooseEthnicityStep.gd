extends Control

signal ethnicity_chosen(trait_element, current_ethnicity, bonus_attribute)
signal attribute_chosen(bonus_attribute)

export(ButtonGroup) var trait_group

var ethnicities = []
var ethnicity_list = []
var attributes_list = []
var current_ethnicity = 0
var current_ethnicity_identifier = "southern_hegemony"
var ethnicity = {}
var attribute_string

onready var picture = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/EthnicityPic
onready var ethnicity_name = $VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/EthnicityName
onready var ethnicity_description = $VBoxContainer/HBoxContainer/VBoxContainer/TextureRect/HBoxContainer/VBoxContainer/EthnicityDescription
onready var trait_container = $VBoxContainer/HBoxContainer/VBoxContainer/TraitContainer
onready var attribute_bonus_label = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/VBoxContainer/HBoxContainer/AttributeBonus
onready var attribute_selector = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/VBoxContainer/HBoxContainer/AttributeSelect
onready var trait_button_scene = preload("res://EthnicityPage/EthnicityTrait.tscn")
onready var alternate_trait_button_scene = preload("res://EthnicityPage/EthnicityJackOfAllTradesSquaredTrait.tscn")
onready var database = get_node("/root/DatabaseOperations")


func _ready():
	ethnicity_list = database.read_ethnicity_identifiers() # zwraca listę enthnicity_identifier
	ethnicities = database.read_table_from_database("ethnicity") # dawny odczyt starej bazy
	ethnicity = database.read_data_for_etnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"]) #.ethnicity_identifier,ethnicity_name,splash_art_path,ethnicity_description;
	print ("current_ethnicity =" + str(current_ethnicity))
	load_ethnicity(ethnicity)
#	var attributes_list = database.read_attributes_name_without_any()
#	for attribute in attributes_list:
#		attribute_selector.add_item(attribute["attribute_name"])
#	fill_attribute_bonus(ethnicity["attribute_identifier"])
	for attribute in GlobalConstants.attribute_string:
		attribute_selector.add_item(attribute)
	fill_attribute_bonus(ethnicities[current_ethnicity]["Attribute"])
	trait_group = load("res://EthnicityPage/Traits.tres")
	trait_group = load("res://EthnicityPage/Traits.tres")
	

func _set_image(path):
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)


func load_ethnicity(ethnicity):
	_set_image(ethnicity["splash_art_path"]) 
	ethnicity_name.bbcode_text = "[center]%s[/center]" % ethnicity["ethnicity_name"]
	ethnicity_description.bbcode_text = "%s" % ethnicity["ethnicity_description"].replace("\n", "\n")
	var trait_list = database.read_traits_for_ethnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"]) #t.trait_identifier, t.trait_name, t.trait_description
	if trait_container.get_child_count() > 0:
		for n in trait_container.get_children():
			trait_container.remove_child(n)
			n.queue_free()
	for trait in trait_list:
		if trait["trait_identifier"] == "versatility_squared":
			var trait_button = create_trait_button(alternate_trait_button_scene, trait)
			var trait_button_trait_list = trait_button.get_node("MarginContainer/VBoxContainer/OptionButton")
			fill_trait_button_trait_list(trait_button_trait_list)
			trait_button.secondary_trait = trait_button.option_button.get_item_text(0)
			trait_button.get_node(".").set_button_group(trait_group)
			
		else:
			var trait_button = create_trait_button(trait_button_scene, trait)
			trait_button.get_node(".").set_button_group(trait_group)


func create_trait_button(trait_template, trait_data):
	var trait_button = trait_template.instance()
	trait_container.add_child(trait_button)
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % trait_data["trait_name"]
	trait_button.trait_description_label.bbcode_text = "%s" % trait_data["trait_description"]
	trait_button.connect("trait_button_pressed", 
						self, 
						"_on_Trait_Button_button_pressed")
	trait_button.ID = trait_data["trait_identifier"]
	trait_button.trait_name = trait_data["trait_name"]
	trait_button.description = trait_data["trait_description"]
	return trait_button


func _on_Trait_Button_button_pressed(button):
	var bonus_attribute
	
	if ethnicity_list[current_ethnicity]["ethnicity_identifier"] =="not_your_business":
		bonus_attribute = attribute_selector.selected
	else:
		bonus_attribute = ethnicities[current_ethnicity]["Attribute"]
	emit_signal("ethnicity_chosen", button, ethnicities[current_ethnicity], bonus_attribute)


func fill_trait_button_trait_list(trait_list_element: OptionButton):
	for ethnicity in ethnicities:
		if !(ethnicity["Name"] == "Nie twój zasrany interes"):
			for trait in ethnicity["Traits"]:
				trait_list_element.add_item(trait["TraitName"])


#func fill_attribute_bonus(attribute_identifier):
#	if ethnicity["ethnicity_identifier"] =="not_your_business":
#		attribute_bonus_label.visible = false
#		attribute_selector.visible = true
#		return
#	attribute_selector.visible = false
#	attribute_bonus_label.visible = true
#	var attribute_string = database.read_attribute_data(attribute_identifier)
#	attribute_bonus_label.bbcode_text = "[right]%s +1[/right]" % attribute_string["attribute_name"]

func fill_attribute_bonus(attribute):
	if ethnicities[current_ethnicity]["Name"] =="Nie twój zasrany interes":
		attribute_bonus_label.visible = false
		attribute_selector.visible = true
		return
	attribute_selector.visible = false
	attribute_bonus_label.visible = true
	attribute_bonus_label.bbcode_text = "[right]%s +1[/right]" % GlobalConstants.attribute_string[attribute]


func _on_AttributeSelect_item_selected(index):
	emit_signal("attribute_chosen", index)


func _on_PreviousEthnicity_button_up():
	
	if current_ethnicity == 0:
		current_ethnicity = len(ethnicities)-1
	else:
		current_ethnicity -= 1
	ethnicity = database.read_data_for_etnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"])
	load_ethnicity(ethnicity)
#	fill_attribute_bonus(ethnicity["attri"])
	fill_attribute_bonus(ethnicities[current_ethnicity]["Attribute"])

func _on_NextEthnicity_button_up():
	if current_ethnicity == len(ethnicities)-1:
		current_ethnicity = 0
	else:
		current_ethnicity += 1
	ethnicity = database.read_data_for_etnicity(ethnicity_list[current_ethnicity]["ethnicity_identifier"])
	load_ethnicity(ethnicity)
#	fill_attribute_bonus(ethnicity["attri"])
	fill_attribute_bonus(ethnicities[current_ethnicity]["Attribute"])




