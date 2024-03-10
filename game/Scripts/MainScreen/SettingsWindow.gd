extends Node


#####################################
# SIGNALS
#####################################
signal back_to_main_menu
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
var language_data = []
#####################################
# ONREADY VARIABLES
#####################################
onready var language_selector: OptionButton = $"%LanguageSelector"
onready var close_button = $"%CloseButton"
onready var all_skill_point_selector = $"%AllSkillPointsSelector"
onready var spec_skill_point_selector = $"%SpecSkillPointsSelector"
onready var illness_selection_mode = $"%IllnessSelectionMode"
#####################################
# OVERRIDE FUNCTIONS
#####################################

func _ready() -> void:
	language_data = DatabaseOperations.get_languages_data()
	fill_language_options()
	for i in range(0,len(language_data)):
		if language_data[i]["language_locale"] == GlobalVariables.language:
			_on_LanguageSelector_item_selected(i)
	all_skill_point_selector.value = GlobalVariables.max_skill_points
	spec_skill_point_selector.value = GlobalVariables.max_specialization_skill_points
	illness_selection_mode.select(GlobalVariables.illness_mode)
	
#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################

func fill_language_options():
	for language in language_data:
		language_selector.add_item(tr(language['language_key']))

func _on_LanguageSelector_item_selected(index:int):
	language_selector.clear()
	TranslationServer.set_locale(language_data[index]["language_locale"])
	fill_language_options()
	language_selector.select(index)


func _on_CloseButton_button_up():
	emit_signal("back_to_main_menu")


func _on_SpecSkillPointsSelector_value_changed(value:float):
	GlobalVariables.max_specialization_skill_points = value

func _on_AllSkillPointsSelector_value_changed(value:float):
	GlobalVariables.max_skill_points = value


func _on_IllnessSelectionMode_item_selected(index):
	GlobalVariables.illness_mode = index
