extends Button

onready var TraitNameLabel = $MarginContainer/VBoxContainer/TraitNameLabel
signal traitButtonUp(button)

export var ID: String
export var traitName: String
export var description: String

func _ready():
	pass # Replace with function body.

func _on_Button_button_up():
	emit_signal("traitButtonUp", self)
