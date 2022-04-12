extends TextureButton

signal profession_trait_button_pressed(button)
export var ID: String
export var trait_name: String
export var description: String

export (NodePath) onready var trait_name_label = get_node(trait_name_label) as RichTextLabel
export (NodePath) onready var trait_description_label = get_node(trait_description_label) as RichTextLabel


func _ready():
	pass # Replace with function body.


func _on_ProfesionTraitButton_pressed():
	emit_signal("profession_trait_button_pressed", self)
