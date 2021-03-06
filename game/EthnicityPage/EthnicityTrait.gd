extends TextureButton

signal trait_button_pressed(button)
export var identifier: String
export var trait_name: String
export var description: String

export (NodePath) onready var trait_name_label = get_node(trait_name_label) as RichTextLabel
export (NodePath) onready var trait_description_label = get_node(trait_description_label) as RichTextLabel


func _on_EthnicityTraitButton_pressed():
	emit_signal("trait_button_pressed", self)
