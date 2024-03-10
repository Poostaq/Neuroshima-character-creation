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
	GlobalVariables.global_randomizer = RandomNumberGenerator.new()
	GlobalVariables.global_randomizer.randomize()



#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################


func _on_NewCharacterButton_button_up():
	DatabaseOperations.create_new_character_entry()
	CharacterStats.player_id = DatabaseOperations.return_current_player_id()
	DatabaseOperations.set_creation_date(CharacterStats.player_id)
	main_menu.visible = false
	character_creation_process.visible = true
	character_creation_process.steps[character_creation_process.current_step].load_step()
	CharacterStats.player_seed = GlobalVariables.global_randomizer.seed
	print("PLAYER SEED:")
	print(CharacterStats.player_seed)
	print("------------")
	CharacterStats.player_seed_state = GlobalVariables.global_randomizer.state
	print("PLAYER SEED STATE:")
	print(CharacterStats.player_seed_state)
	print("------------")


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
