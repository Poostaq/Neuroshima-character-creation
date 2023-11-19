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

func _back_to_main_menu():
	main_menu.visible = true
	character_creation_process.visible = false
