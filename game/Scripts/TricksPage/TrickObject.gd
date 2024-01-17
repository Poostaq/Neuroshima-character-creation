extends Button

signal trick_button_pressed(trick_data)

onready var trick_name = $"%TrickName"
export var trick_data: Dictionary



func set_trick_name():
	if trick_data:
		trick_name.text = tr(trick_data["trick_name"])
	else:
		trick_name.text = "NAME NOT FOUND"



func _on_TrickObject_button_up():
	emit_signal("trick_button_pressed", trick_data["trick_name"])
