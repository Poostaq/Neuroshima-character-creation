extends Label


onready var draggable_value = preload("res://Scenes/AttributesPage/DraggableValue.tscn")
signal dropped_data


func get_drag_data(_pos) -> Dictionary:
	var data = {}
	data["text"] = self.text
	data["original_object"] = self
	var drag_element = draggable_value.instance()
	drag_element.get_node("TEXT").text = self.text
	set_drag_preview(drag_element)
	return data


func can_drop_data(_position, _data) -> bool:
	return true


func drop_data(_position, data) -> void:
	if self.text == "":
		self.text = data["text"]
		data["original_object"].text = ""
		emit_signal("dropped_data")
	else:
		var current_text = self.text
		self.text = data["text"]
		data["original_object"].text = current_text
		emit_signal("dropped_data")
