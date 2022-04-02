extends Control

export(ButtonGroup) var traitGroup

onready var picture = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/EthnicityPic
onready var ethnicity_name = $VBoxContainer/HBoxContainer2/HBoxContainer/VBoxContainer/EthnicityName
onready var ethnicity_description = $VBoxContainer/HBoxContainer/VBoxContainer/TextureRect/HBoxContainer/VBoxContainer/EthnicityDescription
onready var traitContainer = $VBoxContainer/HBoxContainer/VBoxContainer/TraitContainer
onready var attributeBonusLabel = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/VBoxContainer/HBoxContainer/AttributeBonus
onready var attributeSelector = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/VBoxContainer/HBoxContainer/AttributeSelect

onready var traitButtonScene = preload("res://EthnicityPage/EthnicityTrait.tscn")
onready var alternateTraitButtonScene = preload("res://EthnicityPage/EthnicityJackOfAllTradesSquaredTrait.tscn")

onready var database = get_node("/root/DatabaseOperations")

signal ethnicity_chosen(traitElement, currentEthnicity, bonusAttribute)
signal attribute_chosen(bonusAttribute)

var ethnicities = []
var current_ethnicity = 0

func _ready():
	ethnicities = database.read_table_from_database("ethnicity")
	load_ethnicity(ethnicities[current_ethnicity])
	for attribute in GlobalConstants.attribute_string:
		attributeSelector.add_item(attribute)
	fillAttributeBonus(ethnicities[current_ethnicity]["Attribute"])
	traitGroup = load("res://EthnicityPage/Traits.tres")
	

func _set_image(path):
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)



func load_ethnicity(ethnicity):
	_set_image(ethnicity["SplashArtPath"])
	ethnicity_name.bbcode_text = "[center]%s[/center]" % ethnicity["Name"]
	ethnicity_description.bbcode_text = "%s" % ethnicity["Description"].replace("\\n", "\n")
	
	var traitList = ethnicity["Traits"]
	if traitContainer.get_child_count() > 0:
		for n in traitContainer.get_children():
			traitContainer.remove_child(n)
			n.queue_free()
	for trait in traitList:
		if trait["TraitName"] == "Wszechstronność do kwadratu":
			var traitButton = createTraitButton(alternateTraitButtonScene, trait)
			var traitButtonTraitList = traitButton.get_node("MarginContainer/VBoxContainer/OptionButton")
			fillTraitButtonTraitList(traitButtonTraitList)
			traitButton.secondary_trait = traitButton.option_button.get_item_text(0)
			traitButton.get_node(".").set_button_group(traitGroup)
			
		else:
			var traitButton = createTraitButton(traitButtonScene, trait)
			traitButton.get_node(".").set_button_group(traitGroup)

func createTraitButton(traitTemplate, traitData):
	var traitButton = traitTemplate.instance()
	traitContainer.add_child(traitButton)
	var traitName = traitButton.get_node("MarginContainer/VBoxContainer/TraitNameLabel")
	traitName.bbcode_text = "[center]%s[/center]" % traitData["TraitName"]
	var traitDescription = traitButton.get_node("MarginContainer/VBoxContainer/TraitDescriptionLabel")
	traitDescription.bbcode_text = "%s" % traitData["TraitDescription"]
	traitButton.connect("traitButtonPressed", 
						self, 
						"_on_Trait_Button_button_pressed")
	traitButton.ID = traitData["ID"]
	traitButton.traitName = traitData["TraitName"]
	traitButton.description = traitData["TraitDescription"]
	return traitButton

func _on_PreviousEthnicity_button_up():
	if current_ethnicity == 0:
		current_ethnicity = len(ethnicities)-1
	else:
		current_ethnicity -= 1
	load_ethnicity(ethnicities[current_ethnicity])
	fillAttributeBonus(ethnicities[current_ethnicity]["Attribute"])


func _on_NextEthnicity_button_up():
	if current_ethnicity == len(ethnicities)-1:
		current_ethnicity = 0
	else:
		current_ethnicity += 1
	load_ethnicity(ethnicities[current_ethnicity])
	fillAttributeBonus(ethnicities[current_ethnicity]["Attribute"])

func _on_Trait_Button_button_pressed(button):
	var bonusAttribute
	if ethnicities[current_ethnicity]["Name"] =="Nie twój zasrany interes":
		bonusAttribute = attributeSelector.selected
	else:
		bonusAttribute = ethnicities[current_ethnicity]["Attribute"]
	emit_signal("ethnicity_chosen", button, ethnicities[current_ethnicity], bonusAttribute)

func fillTraitButtonTraitList(traitListElement: OptionButton):
	for ethnicity in ethnicities:
		if !(ethnicity["Name"] == "Nie twój zasrany interes"):
			for trait in ethnicity["Traits"]:
				traitListElement.add_item(trait["TraitName"])
		
func fillAttributeBonus(attribute):
	if ethnicities[current_ethnicity]["Name"] =="Nie twój zasrany interes":
		attributeBonusLabel.visible = false
		attributeSelector.visible = true
		return
	attributeSelector.visible = false
	attributeBonusLabel.visible = true
	attributeBonusLabel.bbcode_text = "[right]%s +1[/right]" % GlobalConstants.attribute_string[attribute]


func _on_AttributeSelect_item_selected(index):
	emit_signal("attribute_chosen", index)
