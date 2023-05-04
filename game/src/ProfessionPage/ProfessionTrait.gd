extends TextureButton

signal profession_trait_button_pressed(button)
export var identifier: String
export var trait_name: String
export var description: String
export var tooltip_text: String

export (NodePath) onready var trait_name_label = get_node(trait_name_label) as RichTextLabel
export (NodePath) onready var trait_description_label = get_node(trait_description_label) as RichTextLabel


func _on_ProfesionTraitButton_pressed() -> void:
	emit_signal("profession_trait_button_pressed", self)

func get_tooltip_text() -> String:
	return "%s \n\n %s" % [trait_name, tooltip_text]
	
