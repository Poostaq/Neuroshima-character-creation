extends Control

signal attributes_selected
signal attributes_cleared


onready var distribute_attributes_ui = $"%DistributeAttributesUI"
onready var roll_attributes_ui = $"%RollAttributesUI"

onready var rolling_button = $"%RollingButton"
onready var distribute_button = $"%DistributeButon"

onready var distribute_remaining_points = $"%RemainingPoints"
onready var attribute_description = $"%AttributeDescription"
onready var attribute_description_name = $"%AttributeDescriptionName"

onready var distribute_agility_container = $"%DistributeAgilityContainer"
onready var distribute_perception_container = $"%DistributePerceptionContainer"
onready var distribute_character_container = $"%DistributeCharacterContainer"
onready var distribute_wits_container = $"%DistributeWitsContainer"
onready var distribute_body_container = $"%DistributeBodyContainer"

onready var agility_container = $"%AgilityContainer"
onready var perception_container = $"%PerceptionContainer"
onready var character_container = $"%CharacterContainer"
onready var wits_container = $"%WitsContainer"
onready var body_container = $"%BodyContainer"

onready var agility_name_container = $"%AgilityNameContainer"
onready var perception_name_container = $"%PerceptionNameContainer"
onready var character_name_container = $"%CharacterNameContainer"
onready var wits_name_container = $"%WitsNameContainer"
onready var body_name_container = $"%BodyNameContainer"


onready var distribute_container_list = [
	distribute_agility_container, 
	distribute_perception_container, 
	distribute_character_container, 
	distribute_wits_container, 
	distribute_body_container]

onready var roll_container_list = [
	agility_container,
	perception_container,
	character_container,
	wits_container,
	body_container]

onready var attribute_name_button_list = [
	agility_name_container,
	perception_name_container,
	character_name_container,
	wits_name_container,
	body_name_container]


onready var distribution_attribute_value_list = [12,12,12,12,12,0]
onready var rolling_value_list = [0,0,0,0,0,]

enum {DISTRIBUTING_ROLL, REDISTRIBUTTING_ATTRIBUTE, WAITING_FOR_BUTTON_PRESS}
var status = WAITING_FOR_BUTTON_PRESS

func _ready() -> void:
	for container in distribute_container_list:
		var minus = container.get_node("Minus")
		minus.connect("button_up", self, "on_minus_button_up",[minus])
		var plus = container.get_node("Plus")
		plus.connect("button_up", self, "on_plus_button_up",[plus])
	for container in roll_container_list:
		var selector = container.get_node("Selector")
		selector.connect("button_up", self, "on_selector_button_up",[container])
	for container in attribute_name_button_list:
		var button = container.get_node("AttributeName")
		button.connect("toggled", self, "_on_AttributeName_toggled", [container])

func load_step() -> void:
	attribute_description.bbcode_text = tr("select_attribute_label")
	attribute_description_name.text = ""
	save_attributes()
	if distribution_attribute_value_list[5] == 0:
		emit_signal("attributes_selected")


func clean_up_step() -> void:
	CharacterStats.clear_base_rolls_attributes()
	distribution_attribute_value_list = [12,12,12,12,12,0]
	rolling_value_list = [0,0,0,0,0,]
	update_values_on_ui()
	set_rolling_button_states()
	save_attributes()
	set_distribution_button_states()
	emit_signal("attributes_selected")

func attribute_value_label(attribute_container_element:Control):
	return attribute_container_element.get_node("AttributeValue/Label")


func attribute_value_labels_list(containers):
	var list = []
	for x in containers:
		list.append(attribute_value_label(x))
	return list


func _roll_attribute_above_six() -> Array:
	var average = 0
	var results = []
	while average <= 5:
		results = Dices.roll_dice(3, 20)
		average = ceil((results[0]+results[1]+results[2])/3.0)
	return results


func on_minus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("./../AttributeValue/Label") as Label
	var value = value_element.stat
	if distribution_attribute_value_list[value] > 4:
		distribution_attribute_value_list[value] -= 1
		distribution_attribute_value_list[5] += 1
	update_values_on_ui()
	set_distribution_button_states()
	save_attributes()
	send_signal_to_main()
	
func on_plus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("./../AttributeValue/Label") as Label
	var value = value_element.stat
	if distribution_attribute_value_list[value] < 19 and distribution_attribute_value_list[5] > 0:
		distribution_attribute_value_list[value] += 1
		distribution_attribute_value_list[5] -= 1
	update_values_on_ui()
	save_attributes()
	set_distribution_button_states()
	send_signal_to_main()


func save_attributes() -> void:
	var list = []
	if rolling_button.is_pressed():
		list = rolling_value_list
	elif distribute_button.is_pressed():
		list = distribution_attribute_value_list.slice(0, 4)
	CharacterStats._on_AttributesStep_attributes_chosen(list)


func _on_Button_toggled(_button_pressed:bool):
	clean_up_step()
	if rolling_button.is_pressed():
		distribute_attributes_ui.visible = false
		roll_attributes_ui.visible = true
	elif distribute_button.is_pressed():
		distribute_attributes_ui.visible = true
		roll_attributes_ui.visible = false


func update_values_on_ui():
	var container_list
	var attribute_list
	if rolling_button.is_pressed():
		container_list = roll_container_list
		attribute_list = rolling_value_list
	elif distribute_button.is_pressed():
		distribute_remaining_points.get_node("Label").text = "%s" % distribution_attribute_value_list[5]
		container_list = distribute_container_list
		attribute_list = distribution_attribute_value_list
	for index in range(len(container_list)):
		var element = attribute_value_label(container_list[index])
		element.text = "%s" % attribute_list[index]
	

func on_RollButton_button_up():
	status = WAITING_FOR_BUTTON_PRESS
	clean_up_step()
	var final_values_list = []
	for x in 6:
		var result_rolls = _roll_attribute_above_six()
		var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
		final_values_list.append(final_value)
	var smallest_value_index = final_values_list.find(final_values_list.min())	
	final_values_list.pop_at(smallest_value_index)
	rolling_value_list = final_values_list
	update_values_on_ui()
	emit_signal("attributes_selected")
	set_all_attribute_selectors_active()


func set_distribution_button_states():
	for index in len(distribute_container_list):
		var minus = distribute_container_list[index].get_node("Minus")
		var plus = distribute_container_list[index].get_node("Plus")
		if distribution_attribute_value_list[5] == 0 or distribution_attribute_value_list[index] == 19:
			plus.disabled = true
		else:
			plus.disabled = false
		if distribution_attribute_value_list[index] == 4:
			minus.disabled = true
		else:
			minus.disabled = false

func set_rolling_button_states():
	for container in roll_container_list:
		var selector = container.get_node("Selector")
		if container.get_node("AttributeValue/Label").text == "0":
			selector.disabled = true
		else:
			selector.disabled = false


func on_selector_button_up(container):
	if status == WAITING_FOR_BUTTON_PRESS:
		set_all_attribute_selectors_active()
		container.get_node("Selector").disabled = true
		status = REDISTRIBUTTING_ATTRIBUTE
		return
	if status == REDISTRIBUTTING_ATTRIBUTE:
		var origin_container = null
		for old_container in roll_container_list:
			if old_container.get_node("Selector").disabled == true:
				origin_container = old_container
		var swapped_node_index1 = roll_container_list.find(container)
		var swapped_node_index2 = roll_container_list.find(origin_container)
		var old_value = rolling_value_list[swapped_node_index1]
		rolling_value_list[swapped_node_index1] = rolling_value_list[swapped_node_index2]
		rolling_value_list[swapped_node_index2] = old_value
		update_values_on_ui()
		set_rolling_button_states()
		send_signal_to_main()
		save_attributes()
		status = WAITING_FOR_BUTTON_PRESS
		return


func set_all_attribute_selectors_active():
	for selector_container in roll_container_list:
		var selector = selector_container.get_node("Selector")
		selector.disabled = false


func send_signal_to_main():
	if rolling_button.is_pressed():
		var send_signal = true
		for value in roll_container_list:
			if attribute_value_label(value).text == "0":
				send_signal = false
		if send_signal == true:
			emit_signal("attributes_selected")
	elif distribute_button.is_pressed():
		if distribution_attribute_value_list[5] == 0:
			emit_signal("attributes_selected")
		else:
			emit_signal("attributes_cleared")


func _on_AttributeName_toggled(button_state: bool, container: Control):
	if button_state:
		var index = attribute_name_button_list.find(container)
		var names_array = DatabaseOperations.read_list_of_attributes_without_any()
		print(names_array)
		var description_array = DatabaseOperations.read_list_of_attribute_descriptions_without_any()
		attribute_description.bbcode_text = tr(description_array[index])
		attribute_description_name.text = "%s:" % tr(names_array[index])

