extends TextureButton


#####################################
# SIGNALS
#####################################
signal plus_button_pressed(skill)
signal minus_button_pressed(skill)
signal skill_element_pressed(skill)
#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export var level = 0
export var description = ""
export var skill_name = ""
export var specialization = ""
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################

#####################################
# ONREADY VARIABLES
#####################################
export (NodePath) onready var skill_card_name = get_node(skill_card_name) as Label
export (NodePath) onready var skill_card_level = get_node(skill_card_level) as Label
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

func update_skill_card_text():
	skill_card_name.text = "%s" % skill_name
	skill_card_level.text = "%s" % str(level)
	
#####################################
# HELPER FUNCTIONS
#####################################

func _on_MinusButton_button_up():
	emit_signal("minus_button_pressed", self)


func _on_SkillCard_button_up():
	emit_signal("skill_element_pressed", self)


func _on_PlusButton_button_up():
	emit_signal("plus_button_pressed", self)
