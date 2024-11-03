class_name EquipmentItem

var id: int
var eq_name: String
var additional_info: String
var value: int
var alternate_value: int
var group_id: String

func _init(new_id,
			new_eq_name, 
			new_additional_info, 
			new_value,
			new_alternate_value,
			new_group_id):
	id = new_id
	eq_name = new_eq_name
	if new_additional_info:
		additional_info = new_additional_info
	value = new_value
	if new_alternate_value:
		alternate_value = new_alternate_value
	group_id = new_group_id
