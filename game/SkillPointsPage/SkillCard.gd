extends Node


#####################################
# SIGNALS
#####################################
signal plus_button_pressed(skill)
signal minus_button_pressed(skill)
#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export var skill_level = 0
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################

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


func _process(_delta: float) -> void:
	pass

#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################


func _on_PlusButton_pressed():
	emit_signal("plus_button_pressed", self)


func _on_MinusButton_button_up():
	emit_signal("minus_button_pressed", self)
