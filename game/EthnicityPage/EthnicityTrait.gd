extends TextureButton

onready var TraitNameLabel = $MarginContainer/VBoxContainer/TraitNameLabel
signal traitButtonPressed(button)

export var ID: String
export var traitName: String
export var description: String

func _ready():
	pass # Replace with function body.

#func _on_Button_button_up():
#	emit_signal("traitButtonUp", self)


func _on_Button_pressed():
	emit_signal("traitButtonPressed", self)
