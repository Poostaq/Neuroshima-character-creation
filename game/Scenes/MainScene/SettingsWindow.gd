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
#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass


func _ready() -> void:
	language_data = DatabaseOperations.get_languages_data()
	fill_language_options()


func _process(_delta: float) -> void:
	pass

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
