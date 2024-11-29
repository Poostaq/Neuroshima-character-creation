extends Control

onready var item_list_option_button = $"%ItemListOptionButton"


func fill_option_button(items_list):
	for item in items_list:
		item_list_option_button.add_item(item.eq_name)
