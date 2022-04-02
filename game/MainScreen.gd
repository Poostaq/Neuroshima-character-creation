extends Control

onready var cardButton = $CardButton
onready var character_sheet_panel = $CharacterSheet
onready var ethnicity_element = $CenterContainer/VBoxContainer/StepContainer/Ethnicity
onready var database = get_node("/root/DatabaseOperations")


func _ready():
	pass
	

func _on_CardButton_button_up():
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_values()
