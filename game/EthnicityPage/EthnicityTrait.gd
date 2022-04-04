extends TextureButton

signal trait_button_pressed(button)
export var ID: String
export var trait_name: String
export var description: String

onready var trait_name_label = $MarginContainer/VBoxContainer/TraitNameLabel
onready var trait_description_label = $MarginContainer/VBoxContainer/TraitDescriptionLabel


func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	emit_signal("trait_button_pressed", self)
