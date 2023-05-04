extends RichTextLabel


#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export var tooltip_text : String
export var attribute : int
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
	tooltip_text = DatabaseOperations.read_list_of_attribute_descriptions_without_any()[attribute]


func _process(_delta: float) -> void:
	pass

#####################################
# API FUNCTIONS
#####################################
func get_tooltip_text() -> String:
	return "%s \n %s" % [bbcode_text, tooltip_text]
#####################################
# HELPER FUNCTIONS
#####################################


