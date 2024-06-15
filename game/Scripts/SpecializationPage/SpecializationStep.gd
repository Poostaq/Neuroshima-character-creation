extends Node


#####################################
# SIGNALS
#####################################
signal specialization_chosen()
signal specialization_cleared()
#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
onready var specialization_skills = $"%SpecializationSkills"
onready var specialization_name = $"%SpecializationName"
onready var specialization_description = $"%SpecializationDescription"
onready var selected_identifier = $"%SelectedIdentifier"

#####################################
# PUBLIC VARIABLES 
#####################################
var step_name = "specialization_step_description"
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
	CharacterStats.update_attribute_values()
	_specialization_list = db.read_specialization_identifiers()
	_load_specialization(_get_current_secialization_identifier())
	
func clean_up_step() -> void:
	_clear_specialization()
	CharacterStats.clear_specialization()

#####################################
# HELPER FUNCTIONS
#####################################
func _load_specialization(specialization_id) -> void:
	var specialization_data = db.read_data_for_specialization(specialization_id)
	current_specialization = specialization_data
	print(specialization_data["specialization_name"])
	specialization_name.text = tr(specialization_data["specialization_name"])
	print(specialization_data["specialization_description"])
	specialization_description.bbcode_text = "%s" % tr(specialization_data["specialization_description"])
	specialization_skills.bbcode_text = _prepare_specialization_skills(specialization_data["specialization_identifier"])


func _get_current_secialization_identifier():
	return _specialization_list[_current_specialization_index]["specialization_identifier"]

func _prepare_specialization_skills(specialization_data: String) -> String:
	var specialization_packs_list = db.read_packs_for_specialization(specialization_data)
	var skill_packs = db.create_skill_packs_from_database_query_result(specialization_packs_list)
	var bbcode = ""
	for skill_pack_id in skill_packs.keys():
		bbcode += ("%s %s \n" % [tr("pack_label"), tr(skill_packs[skill_pack_id].name)])
		for skill in skill_packs[skill_pack_id].skill_data:
			bbcode += ("- %s \n" % tr(skill.name))
		bbcode+= "\n"
	return bbcode


func _on_PreviousSpecialization_button_up() -> void:
	if _current_specialization_index == 0:
		_current_specialization_index = len(_specialization_list)-1
	else:
		_current_specialization_index -= 1
	_load_specialization(_get_current_secialization_identifier())
	_clear_specialization()

func _on_NextSpecialization_button_up() -> void:
	if _current_specialization_index == len(_specialization_list)-1:
		_current_specialization_index = 0
	else:
		_current_specialization_index += 1
	_load_specialization(_get_current_secialization_identifier())
	_clear_specialization()

func _on_SelectedIdentifier_pressed():
	emit_signal("specialization_chosen")
	selected_identifier.pressed = true
	selected_identifier.text = tr("select_button_selected")
	CharacterStats._on_specializationStep_specialization_chosen(current_specialization)

func _clear_specialization():
	emit_signal("specialization_cleared")
	selected_identifier.text = tr("select_button")
	selected_identifier.pressed = false
	CharacterStats.clear_specialization()
