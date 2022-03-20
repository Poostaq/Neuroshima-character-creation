extends Control

export var characterStats : Resource

onready var Name = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var Ethnicity = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Ethnicity
onready var EthnicityTrait = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/EthnicityTrait


func _ready():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_CloseButton_button_up():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP

func updateValues():
	Ethnicity.text = characterStats.get("Ethnicity")
	EthnicityTrait.text = characterStats.get("EthnicityTrait")


func _on_Ethnicity_ethnicity_chosen(traitButton, ethnicity):
	self.characterStats.set("Ethnicity", ethnicity["Name"])
	self.characterStats.set("EthnicityTrait", traitButton.traitName)
	self.updateValues()
