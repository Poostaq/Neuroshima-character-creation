extends Node


#####################################
# SIGNALS
#####################################
signal specialization_chosen()
#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export (NodePath) onready var specialization_skills = get_node(specialization_skills) as RichTextLabel
export (NodePath) onready var specialization_name = get_node(specialization_name) as RichTextLabel
export (NodePath) onready var specialization_description = get_node(specialization_description) as RichTextLabel
onready var selected_identifier = $"%SelectedIdentifier"

#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _specialization_list = []
var _current_specialization_index = 0
var current_specialization = {}
#####################################
# ONREADY VARIABLES
#####################################
onready var db = get_node("/root/DatabaseOperations")
#####################################
# OVERRIDE FUNCTIONS
#####################################

#####################################
# API FUNCTIONS
#####################################
func load_step() -> void:
	_specialization_list = db.read_specialization_identifiers()
	var specialization_id = _specialization_list[_current_specialization_index]["specialization_identifier"]
	current_specialization = db.read_data_for_specialization(specialization_id)
	_load_specialization(current_specialization)
	
func clean_up_step() -> void:
	pass

#####################################
# HELPER FUNCTIONS
#####################################
func _load_specialization(specialization_data) -> void:
	specialization_name.bbcode_text = "[center]%s[/center]" % specialization_data["specialization_name"]
	specialization_description.bbcode_text = "%s" % specialization_data["specialization_description"]
	specialization_skills.bbcode_text = _prepare_specialization_skills(specialization_data["specialization_identifier"])


func _prepare_specialization_skills(specialization_data: String) -> String:
	var specialization_packs_list = db.read_packs_for_specialization(specialization_data)
	var bbcode = ""
	for x in specialization_packs_list:
		var skill_pack = x["skill_pack_identifier"]
		bbcode += ("Paczka %s \n" % x["skill_pack_name"])
		var skills = db.read_skills_for_package(skill_pack)
		for y in skills:
			bbcode += ("- %s \n" % y["skill_name"])
		bbcode+= "\n"
	return bbcode


func _on_PreviousSpecialization_button_up() -> void:
	if _current_specialization_index == 0:
		_current_specialization_index = len(_specialization_list)-1
	else:
		_current_specialization_index -= 1
	load_step()
	selected_identifier.pressed = false
	CharacterStats.clear_specialization()

func _on_NextSpecialization_button_up() -> void:
	if _current_specialization_index == len(_specialization_list)-1:
		_current_specialization_index = 0
	else:
		_current_specialization_index += 1
	load_step()
	selected_identifier.pressed = false
	CharacterStats.clear_specialization()

func _on_SelectedIdentifier_pressed():
	emit_signal("specialization_chosen")
	selected_identifier.pressed = true
	CharacterStats._on_specializationStep_specialization_chosen(current_specialization)
