extends Control

onready var picture = $VBoxContainer/HBoxContainer/MarginContainer/EthnicityPic
onready var ethnicity_name = $VBoxContainer/HBoxContainer2/EthnicityName
onready var ethnicity_description = $VBoxContainer/HBoxContainer/VBoxContainer/EthnicityDescription
onready var traitContainer = $VBoxContainer/HBoxContainer/VBoxContainer/TraitContainer

onready var traitButtonScene = preload("res://EthnicityPage/EthnicityTrait.tscn")
onready var alternateTraitButtonScene = preload("res://EthnicityPage/EthnicityJackOfAllTradesSquaredTrait.tscn")

onready var database = get_node("/root/DatabaseOperations")

signal ethnicity_chosen(traitElement, currentEthnicity)

var ethnicities = []
var current_ethnicity = 0


func _ready():
	ethnicities = database.read_table_from_database("ethnicity")
	load_ethnicity(ethnicities[current_ethnicity])


func _set_image(path):
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)



func load_ethnicity(ethnicity):
	_set_image(ethnicity["SplashArtPath"])
	ethnicity_name.bbcode_text = "[center]%s[/center]" % ethnicity["Name"]
	ethnicity_description.bbcode_text = "%s" % ethnicity["Description"]
	
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
		else:
			createTraitButton(traitButtonScene, trait)

func createTraitButton(traitTemplate, traitData):
	var traitButton = traitTemplate.instance()
	traitContainer.add_child(traitButton)
	var traitName = traitButton.get_node("MarginContainer/VBoxContainer/TraitNameLabel")
	traitName.bbcode_text = "[center]%s[/center]" % traitData["TraitName"]
	var traitDescription = traitButton.get_node("MarginContainer/VBoxContainer/TraitDescriptionLabel")
	traitDescription.bbcode_text = "[center]%s[/center]" % traitData["TraitDescription"]
	traitButton.connect("traitButtonUp", 
						self, 
						"_on_Trait_Button_button_up")
	traitButton.ID = traitData["ID"]
	traitButton.traitName = traitData["TraitName"]
	traitButton.description = traitData["TraitDescription"]
	return traitButton

func _on_PreviousEthnicity_button_up():
	if current_ethnicity == -1:
		current_ethnicity = len(ethnicities)-1
	else:
		current_ethnicity -= 1
	load_ethnicity(ethnicities[current_ethnicity])


func _on_NextEthnicity_button_up():
	if current_ethnicity == len(ethnicities):
		current_ethnicity = 0
	else:
		current_ethnicity += 1
	load_ethnicity(ethnicities[current_ethnicity])

func _on_Trait_Button_button_up(button):
	emit_signal("ethnicity_chosen", button, ethnicities[current_ethnicity])

func fillTraitButtonTraitList(traitListElement: OptionButton):
	for ethnicity in ethnicities:
		if !(ethnicity["Name"] == "Nie twój zasrany interes"):
			for trait in ethnicity["Traits"]:
				traitListElement.add_item(trait["TraitName"])
		
