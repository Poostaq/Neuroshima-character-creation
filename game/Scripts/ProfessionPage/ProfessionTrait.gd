extends Button

signal profession_trait_button_pressed(button)
export var identifier: String
export var trait_name: String
export var description: String
export var tooltip_text: String


onready var trait_name_label = $"%TraitNameLabel"
onready var trait_description_label = $"%TraitDescriptionLabel"


func _on_ProfesionTraitButton_pressed() -> void:
	emit_signal("profession_trait_button_pressed", self)

func get_tooltip_text() -> String:
	return "%s \n\n %s" % [trait_name, tooltip_text]
	
