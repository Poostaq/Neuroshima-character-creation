extends Button

signal trait_button_pressed(button)

export var identifier: String
export var trait_name: String
export var description: String
export var tooltip_text : String
export var trait_id : int

onready var trait_name_label = $"%TraitNameLabel"
onready var trait_description_label = $"%TraitDescriptionLabel"


func _on_EthnicityTraitButton_pressed():
	emit_signal("trait_button_pressed", self)

func get_tooltip_text():
	return "%s \n\n %s" % [trait_name, tooltip_text]
