extends Node


#####################################
# SIGNALS
#####################################
signal specialization_chosen(current_specialisation)
#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export (NodePath) onready var specialisation_skills = get_node(specialisation_skills) as RichTextLabel
export (NodePath) onready var specialization_name = get_node(specialization_name) as RichTextLabel
export (NodePath) onready var specialization_description = get_node(specialization_description) as RichTextLabel
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _specialisation_list = []
var _current_specialisation_index = 0
var current_specialization = {}
#####################################
# ONREADY VARIABLES
#####################################
onready var db = get_node("/root/DatabaseOperations")
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
func load_step() -> void:
	_specialisation_list = db.read_specialisation_identifiers()
	var specialisation_id = _specialisation_list[_current_specialisation_index]["specialization_identifier"]
	current_specialization = db.read_data_for_specialisation(specialisation_id)
	_load_specialisation(current_specialization)
	emit_signal("specialization_chosen", current_specialization)
	
	

#####################################
# HELPER FUNCTIONS
#####################################
func _load_specialisation(specialization_data):
	specialization_name.bbcode_text = "[center]%s[/center]" % specialization_data["specialization_name"]
	specialization_description.bbcode_text = "%s" % specialization_data["specialization_description"]
	specialisation_skills.bbcode_text = _prepare_specialization_skills(specialization_data["specialization_identifier"])


func _prepare_specialization_skills(specialization_data):
	var specialization_packs_list = db.read_packs_for_specialization(specialization_data)
	var bbcode = ""
	for x in specialization_packs_list:
		var skill_pack = x["skill_pack_identifier"]
		bbcode += ("Paczka %s \n" % x["skill_pack_name"])
		var skills = db.read_skills_for_package(skill_pack)
		for y in skills:
			bbcode += ("- %s \n" % y["skill_name"])
	return bbcode


func _on_PreviousSpecialisation_button_up():
	if _current_specialisation_index == 0:
		_current_specialisation_index = len(_specialisation_list)-1
	else:
		_current_specialisation_index -= 1
	load_step()

func _on_NextSpecialisation_button_up():
	if _current_specialisation_index == len(_specialisation_list)-1:
		_current_specialisation_index = 0
	else:
		_current_specialisation_index += 1
	load_step()
