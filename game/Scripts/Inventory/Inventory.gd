extends Control

var step_name = "DUMMY STEP"
var equipment_list = []
var purchasable_item = preload("res://Scenes/Inventory/PurchaseItem.tscn")
var equipment_item = preload("res://Scenes/Inventory/Item.tscn")
onready var available_items_list = $"%AvailableItemsList"
onready var filter_editbox = $"%FilterEditbox"
onready var category_filter = $"%CategoryFilter"
onready var purchase_buy_button = $"%PurchaseBuyButton"
onready var purchase_tab = $"%PurchaseTab"
onready var equipment_tab = $"%EquipmentTab"
onready var purchased_items_list = $"%PurchasedItemsList"


onready var purchase_item_name = $"%PurchaseItemName"
onready var purchase_additional__info = $"%PurchaseAdditional Info"
onready var purchase_amount_label = $"%PurchaseAmountLabel"
onready var purchase_amount_value = $"%PurchaseAmountValue"
onready var purchase_minus = $"%PurchaseMinus"
onready var purchase_plus = $"%PurchasePlus"
onready var purchase_price_label = $"%PurchasePriceLabel"
onready var purchase_price_value = $"%PurchasePriceValue"
onready var purchase_sum_label = $"%PurchaseSumLabel"
onready var purchase_sum_value = $"%PurchaseSumValue"
onready var purchase_window_background = $"%PurchaseWindowBackground"

onready var arrow_up = preload("res://UI_Elements/arrowUpActive.png")
onready var arrow_down = preload("res://UI_Elements/arrowDownActive.png")
onready var name_button = $"%NameButton"
onready var price_button = $"%PriceButton"

onready var regular_item = $"%RegularItem"
onready var custom_item = $"%CustomItem"
onready var custom_item_category = $"%CustomItemCategory"
onready var custom_item_name = $"%CustomItemName"
onready var custom_item_price = $"%CustomItemPrice"
onready var balance_amount_label = $"%BalanceAmountLabel"

var purchased_item_data: EquipmentItem

func _ready():
	if get_tree().current_scene.name == "Inventory":
		load_step()	
	CharacterStats.player_currency = 150
	balance_amount_label.text = str(CharacterStats.player_currency)

func load_step():
	equipment_list = DatabaseOperations.get_equipment_data()
	fill_category_dropdown()
	fill_custom_item_category_dropdown()
	refresh_items_for_purchase_list()
	

func clean_up_step():
	pass

func refresh_items_for_purchase_list():
	for child in available_items_list.get_children():
		child.queue_free()
	for item_data in equipment_list:
		create_list_item(item_data)
	var created_custom_item = _create_custom_item()
	create_list_item(created_custom_item)
	_on_FilterEditbox_text_changed(filter_editbox.text)

func _create_custom_item():
	return EquipmentItem.new(999999,
								"custom_item",
								"",
								0,
								null,
								"any_group")

func create_list_item(item_data):
		var item_element = purchasable_item.instance()
		item_element.item_data = item_data
		available_items_list.add_child(item_element)
		item_element.set_item_name()
		item_element.set_item_value()
		item_element.connect("item_pressed", self, "fill_purchase_window_with_item_data")
	
func fill_category_dropdown():
	var groups = DatabaseOperations.get_equipment_groups()
	category_filter.add_item(tr("any_group"))
	for group_element in groups:
		category_filter.add_item(group_element["group_id"])

func fill_custom_item_category_dropdown():
	var groups = DatabaseOperations.get_equipment_groups()
	for group_element in groups:
		custom_item_category.add_item(group_element["group_id"])

func _on_CategoryFilter_item_selected(_index):
	for child in available_items_list.get_children():
		child.queue_free()
	for item_data in equipment_list:
		var selected_category = category_filter.get_item_text(_index)
		if selected_category != tr("any_group") and item_data["group_id"] != selected_category:
			continue
		create_list_item(item_data)
	_on_FilterEditbox_text_changed(filter_editbox.text)


func _on_FilterEditbox_text_changed(new_text):
	for child in available_items_list.get_children():
		if new_text.to_lower() in child.item_data.eq_name.to_lower():
			child.visible = true
			continue
		elif new_text.to_lower() in child.item_data.additional_info.to_lower():
			child.visible = true
			continue
		elif new_text.to_lower() in tr(child.item_data.group_id).to_lower():
			child.visible = true
			continue
		elif new_text == "":
			child.visible = true
			continue
		else:
			child.visible = false
			
			
func fill_purchase_window_with_item_data(item_data: EquipmentItem):
	purchase_window_background.visible = true
	if item_data.eq_name != "custom_item":
		purchased_item_data = item_data
		regular_item.visible = true
		custom_item.visible = false
		purchase_item_name.text = item_data.eq_name
		purchase_additional__info.text = item_data.additional_info
		purchase_price_value.text = str(item_data.value)
		purchase_amount_value.text = "0"
		purchase_minus.disabled = true
		purchase_sum_value.text = "0"
		purchase_buy_button.disabled = true
		return
	custom_item_name.text = ""
	custom_item_price.value = 0
	custom_item_category.selected = 0
	regular_item.visible = false
	custom_item.visible = true


func _on_PurchaseCancelButton_pressed():
	purchase_window_background.visible = false
	purchased_item_data = null

func _on_NameButton_pressed():
	if name_button.icon == null || name_button.icon == arrow_down:
		name_button.icon = arrow_up
		price_button.icon = null
		sort_list_of_purchasable_items("name", "ascending")
	else:
		name_button.icon = arrow_down
		sort_list_of_purchasable_items("name", "descending")

func _on_PriceButton_pressed():
	if price_button.icon == null || price_button.icon == arrow_down:
		price_button.icon = arrow_up
		name_button.icon = null
		sort_list_of_purchasable_items("value", "ascending")
	else:
		price_button.icon = arrow_down
		sort_list_of_purchasable_items("value", "descending")


func sort_list_of_purchasable_items(sorter: String, direction: String):
	var items = available_items_list.get_children()
	var sorted_items = sort_items(items, sorter, direction)
	for item in sorted_items:
		available_items_list.remove_child(item)
		available_items_list.add_child(item)

func sort_items(items: Array, sorter: String, direction: String) -> Array:
	items.sort_custom(self, get_sort_func_name(sorter, direction))
	return items

func get_sort_func_name(sorter: String, direction: String) -> String:
	if sorter == "name":
		if direction == "descending":
			return "compare_by_name_desc"
		else:
			return "compare_by_name_asc"
	elif sorter == "value":
		if direction == "descending":
			return "compare_by_value_desc"
		else:
			return "compare_by_value_asc"
	else:
		print("Invalid sorter provided: ", sorter)
		return ""

func compare_by_name_asc(a: Node, b: Node) -> bool:
	var item_a = a.item_data
	var item_b = b.item_data
	return item_a.eq_name < item_b.eq_name

func compare_by_name_desc(a: Node, b: Node) -> bool:
	var item_a = a.item_data
	var item_b = b.item_data
	return item_a.eq_name > item_b.eq_name

func compare_by_value_asc(a: Node, b: Node) -> bool:
	var item_a = a.item_data
	var item_b = b.item_data
	return item_a.value < item_b.value

func compare_by_value_desc(a: Node, b: Node) -> bool:
	var item_a = a.item_data
	var item_b = b.item_data
	return item_a.value > item_b.value


func _on_EquipmentButton_pressed():
	purchase_tab.visible = false
	equipment_tab.visible = true
	refresh_items_from_player_equipment()


func _on_SelectButton_pressed():
	purchase_tab.visible = true
	equipment_tab.visible = false
	refresh_items_for_purchase_list()


func _on_PurchaseBuyButton_pressed():
	if CharacterStats.player_currency >= int(purchase_sum_value.text):
		if int(purchase_amount_value.text) > 0:
			var player_item_info = CharacterStats.get_equipment_item_data(purchased_item_data.eq_name)
			if player_item_info.size() == 0:
				CharacterStats.player_equipment.append(
					{"equipment_data": purchased_item_data, 
					"amount": purchase_amount_value.text})
			elif player_item_info.size() != 0:
				print(player_item_info["amount"])
				player_item_info["amount"] = str(int(player_item_info["amount"])+int(purchase_amount_value.text))
			CharacterStats.player_currency -= int(purchase_sum_value.text)
			update_balance_amount_label()
			purchase_window_background.visible = false
			purchased_item_data = null
		
func update_balance_amount_label():
	balance_amount_label.text = str(CharacterStats.player_currency)
	

func _on_PurchasePlus_pressed():
	purchase_amount_value.text = str(int(purchase_amount_value.text)+1)
	purchase_minus.disabled = false
	purchase_sum_value.text = str(int(purchase_sum_value.text)+purchased_item_data.value)
	purchase_buy_button.disabled = false


func _on_PurchaseMinus_pressed():
	purchase_amount_value.text = str(int(purchase_amount_value.text)-1)
	purchase_sum_value.text = str(int(purchase_sum_value.text)-purchased_item_data.value)
	if purchase_amount_value.text == "0":
		purchase_minus.disabled = true
		purchase_buy_button.disabled = true
		

func refresh_items_from_player_equipment():
	for child in purchased_items_list.get_children():
		child.queue_free()
	for item_data in CharacterStats.player_equipment:
		create_equipment_list_item(item_data)
	
	
func create_equipment_list_item(item_data):
		var item_element = equipment_item.instance()
		item_element.item_data = item_data["equipment_data"]
		item_element.item_amount = item_data["amount"]
		purchased_items_list.add_child(item_element)
		item_element.set_item_name()
		item_element.set_item_value()
		item_element.set_item_amount()
		item_element.connect("item_sold", self, "update_balance_amount_label")
		item_element.connect("amount_increased", self, "update_balance_amount_label")
		item_element.connect("amount_reduced", self, "update_balance_amount_label")
