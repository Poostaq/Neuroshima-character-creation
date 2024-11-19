extends Button

signal item_pressed(item_data)


var item_data: EquipmentItem
onready var item_name = $"%ItemName"
onready var item_value = $"%ItemValue"

func set_item_name():
	item_name.text = tr(item_data.eq_name)
	if item_data.additional_info:
		item_name.text = item_name.text + ", " + tr(item_data.additional_info)
	
func set_item_value():
	item_value.text = ""
	if item_data.alternate_value:
		item_value.text = str(item_data.alternate_value) + "/"
	item_value.text = item_value.text + str(item_data.value)



func _on_PurchaseItem_pressed():
	emit_signal("item_pressed", item_data)
