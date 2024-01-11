extends Node


#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################

#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
onready var main_menu =  $"%MainMenu"
onready var character_creation_process =  $"%CharacterCreationProcess"
onready var settings_window = $"%SettingsWindow"

var menu_buttons = []
#####################################
# ONREADY VARIABLES
#####################################

#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass


func _ready() -> void:
	pass



#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################


func _on_NewCharacterButton_button_up():
	main_menu.visible = false
	character_creation_process.visible = true
	character_creation_process.steps[character_creation_process.current_step].load_step()


func _back_to_main_menu():
	main_menu.visible = true
	character_creation_process.visible = false
	settings_window.visible = false


func _on_ExitButton_button_up():
	get_tree().quit()


func _on_SettingsButton_button_up():
	main_menu.visible = false
	settings_window.visible = true


func _on_SaveButton_pressed():
	GlobalVariables.save_config()
	_back_to_main_menu()
