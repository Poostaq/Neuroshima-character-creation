extends Button

signal disease_button_pressed(disease_data)



onready var disease_name = $"%DiseaseName"
export var disease_data: Dictionary
export var disease_index: int


func set_disease_name():
	if disease_data:
		disease_name.text = tr(disease_data["disease_name"])
	else:
		disease_name.text = "NAME NOT FOUND"



func _on_DiseaseObject_button_up():
	emit_signal("disease_button_pressed", disease_data)
