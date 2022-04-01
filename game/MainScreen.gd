extends Control

onready var cardButton = $CardButton
onready var characterSheetPanel = $CharacterSheet
onready var ethnicityElement = $CenterContainer/VBoxContainer/StepContainer/Ethnicity

onready var database = get_node("/root/DatabaseOperations")

func _ready():
	pass
	
func _on_CardButton_button_up():
	characterSheetPanel.visible = true
	characterSheetPanel.mouse_filter = Control.MOUSE_FILTER_PASS
	characterSheetPanel.updateValues()
