extends Label


onready var draggable_value = preload("res://Scenes/AttributesPage/DraggableValue.tscn")
const draggable_only = true


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


func drop_data(_position, _data):
	pass
