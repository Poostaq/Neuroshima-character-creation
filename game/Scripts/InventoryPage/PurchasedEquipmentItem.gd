extends Control

signal item_sold()
signal amount_reduced()
signal amount_increased()

var item_data: EquipmentItem
var item_amount: int
onready var item_name_label = $"%ItemNameLabel"
onready var item_value_label = $"%ItemValueLabel"
onready var item_amount_label = $"%ItemAmountLabel"

func set_item_name():
	item_name_label.text = tr(item_data.eq_name)
	if item_data.additional_info:
		item_name_label.text = item_name_label.text + ", " + tr(item_data.additional_info)
	
func set_item_value():
	item_value_label.text = str(item_data.value)
	
func set_item_amount():
	item_amount_label.text = str(item_amount)

func _on_SellButton_pressed():
	CharacterStats.remove_equipment_item_data(item_data.eq_name)
	CharacterStats.player_currency += int(item_value_label.text) * int(item_amount_label.text)
	emit_signal("item_sold")
	self.queue_free()

func _on_Minus_pressed():
	item_amount -= 1
	CharacterStats.player_currency += int(item_value_label.text)
	var item_statistics = CharacterStats.get_equipment_item_data(item_data.eq_name)
	item_statistics["amount"] = str(int(item_statistics["amount"])-1)
	set_item_amount()
	emit_signal("amount_reduced")
	if item_amount == 0:
		CharacterStats.remove_equipment_item_data(item_data.eq_name)
		self.queue_free()
		

func _on_Plus_pressed():
	if CharacterStats.player_currency > int(item_value_label.text):
		CharacterStats.player_currency -= int(item_value_label.text)
		item_amount += 1
		set_item_amount()
		emit_signal("amount_increased")
		var item_statistics = CharacterStats.get_equipment_item_data(item_data.eq_name)
		item_statistics["amount"] = str(int(item_statistics["amount"])+1)
	
