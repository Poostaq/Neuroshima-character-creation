extends RichTextLabel


onready var draggable_value = preload("res://AttributesPage/DraggableValue.tscn")
signal dropped_data


func get_drag_data(_pos):
	var data = {}
	data["bbcode"] = self.bbcode_text
	data["original_object"] = self
	var drag_element = draggable_value.instance()
	drag_element.get_node("TEXT").bbcode_text = self.bbcode_text
	set_drag_preview(drag_element)
	return data


func can_drop_data(_position, _data):
	return true


func drop_data(_position, data):
	if self.bbcode_text == "":
		self.bbcode_text = data["bbcode"]
		emit_signal("dropped_data")
		data["original_object"].bbcode_text = ""
	else:
		var current_text = self.bbcode_text
		self.bbcode_text = data["bbcode"]
		emit_signal("dropped_data")
		data["original_object"].bbcode_text = current_text
