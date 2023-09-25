extends Control

signal attributes_selected
signal attributes_cleared

export (NodePath) onready var roll_button = get_node(roll_button) as Button
export (NodePath) onready var roll_button_container = get_node(roll_button_container) as CenterContainer

export (NodePath) onready var math1_label = get_node(math1_label) as RichTextLabel
export (NodePath) onready var math2_label = get_node(math2_label) as RichTextLabel
export (NodePath) onready var math3_label = get_node(math3_label) as RichTextLabel
export (NodePath) onready var math4_label = get_node(math4_label) as RichTextLabel
export (NodePath) onready var math5_label = get_node(math5_label) as RichTextLabel
export (NodePath) onready var math6_label = get_node(math6_label) as RichTextLabel

export (NodePath) onready var roll1_label = get_node(roll1_label) as Label
export (NodePath) onready var roll2_label = get_node(roll2_label) as Label
export (NodePath) onready var roll3_label = get_node(roll3_label) as Label
export (NodePath) onready var roll4_label = get_node(roll4_label) as Label
export (NodePath) onready var roll5_label = get_node(roll5_label) as Label

export (NodePath) onready var agility_attribute_val = get_node(agility_attribute_val) as Label
export (NodePath) onready var perception_attribute_val = get_node(perception_attribute_val) as Label
export (NodePath) onready var character_attribute_val = get_node(character_attribute_val) as Label
export (NodePath) onready var wits_attribute_val = get_node(wits_attribute_val) as Label
export (NodePath) onready var body_attribute_val = get_node(body_attribute_val) as Label

export (NodePath) onready var minus_agi_button = get_node(minus_agi_button) as BaseButton
export (NodePath) onready var minus_per_button = get_node(minus_per_button) as BaseButton
export (NodePath) onready var minus_cha_button = get_node(minus_cha_button) as BaseButton
export (NodePath) onready var minus_wit_button = get_node(minus_wit_button) as BaseButton
export (NodePath) onready var minus_bod_button = get_node(minus_bod_button) as BaseButton

export (NodePath) onready var plus_agi_button = get_node(plus_agi_button) as BaseButton
export (NodePath) onready var plus_per_button = get_node(plus_per_button) as BaseButton
export (NodePath) onready var plus_cha_button = get_node(plus_cha_button) as BaseButton
export (NodePath) onready var plus_wit_button = get_node(plus_wit_button) as BaseButton
export (NodePath) onready var plus_bod_button = get_node(plus_bod_button) as BaseButton

export (NodePath) onready var agi_value_label = get_node(agi_value_label) as Label
export (NodePath) onready var per_value_label = get_node(per_value_label) as Label
export (NodePath) onready var cha_value_label = get_node(cha_value_label) as Label
export (NodePath) onready var wit_value_label = get_node(wit_value_label) as Label
export (NodePath) onready var bod_value_label = get_node(bod_value_label) as Label

onready var distribution_attribute_value_element_list = [agi_value_label, per_value_label, cha_value_label, wit_value_label, bod_value_label]

export (NodePath) onready var tab_container = get_node(tab_container) as TabContainer


export (NodePath) onready var remaining_value_label = get_node(remaining_value_label) as Label

onready var math_list = [math1_label,math2_label,math3_label,math4_label,math5_label,math6_label]
onready var roll_list = [roll1_label,roll2_label,roll3_label,roll4_label,roll5_label]
onready var rolling_attribute_value_list = [
	agility_attribute_val,
	perception_attribute_val,
	character_attribute_val,
	wits_attribute_val,
	body_attribute_val
	]

onready var minus_button_list = [minus_agi_button,
	minus_per_button,
	minus_cha_button,
	minus_wit_button,
	minus_bod_button
	]

onready var plus_button_list = [plus_agi_button,
	plus_per_button,
	plus_cha_button,
	plus_wit_button,
	plus_bod_button
	]

#Attributes on indexes: agi:0, per:1, cha:2, wit:3, bod:4, remaining:5
onready var distribution_attribute_value_list = [4,4,4,4,4,40]

var current_roll = 0

func old_ready() -> void:
	for button in minus_button_list:
		button.connect("button_up", self, "_on_minus_button_up",[button])
	for button in plus_button_list:
		button.connect("button_up", self, "_on_plus_button_up",[button])


func load_step() -> void:
	clean_up_step()

func clean_up_step() -> void:
	_clear_rolls()
	_clear_attribute_values()
	_clear_math()
	distribution_attribute_value_list = [4,4,4,4,4,40]
	for index in range(0,len(distribution_attribute_value_element_list)):
		distribution_attribute_value_element_list[index].text = str(distribution_attribute_value_list[index])
	remaining_value_label.text = str(distribution_attribute_value_list[5])
	save_attributes()
	emit_signal("attributes_cleared")

func save_attributes() -> void:
	var list = []
	if tab_container.current_tab == 0:
		list = [
			int(agility_attribute_val.text),
			int(perception_attribute_val.text),
			int(character_attribute_val.text),
			int(wits_attribute_val.text),
			int(body_attribute_val.text),
		]
	elif tab_container.current_tab == 1:
		list =  distribution_attribute_value_list.slice(0, 4)
	CharacterStats._on_AttributesStep_attributes_chosen(list)

func _on_RollButton_button_up() -> void:
	clean_up_step()
	var result_rolls_list = []
	var final_values_list = []
	for x in 6:
		var result_rolls = _roll_attribute_above_six()
		var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
		result_rolls_list.append(result_rolls)
		final_values_list.append(final_value)
	var smallest_value_index = final_values_list.find(final_values_list.min())
	for x in 6:
		var rolls_text = ""
		var value_text = ""
		if x == smallest_value_index:
			rolls_text = "[s][center] (%s+%s+%s)/3= "
			value_text = "[s]%s"
		else:
			rolls_text = "[center] (%s+%s+%s)/3= "
			value_text = "%s"
		math_list[x].bbcode_text = (rolls_text % result_rolls_list[x]) + value_text % str(final_values_list[x])
	final_values_list.pop_at(smallest_value_index)
	for x in range(0, len(final_values_list)):
		roll_list[x].text = "%s" % str(final_values_list[x])


func _roll_attribute_above_six() -> Array:
	var average = 0
	var results = []
	while average <= 5:
		results = Dices.roll_dice(3, 20)
		average = ceil((results[0]+results[1]+results[2])/3.0)
	return results


func _clear_rolls() -> void:
	for roll in roll_list:
		roll.text = ""


func _clear_attribute_values() -> void:
	for attribute in rolling_attribute_value_list:
		attribute.text = ""

func _clear_math() -> void:
	for math in math_list:
		math.bbcode_text = ""

func _on_minus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("../ValueContainer/Value") as Label
	var value = value_element.stat
	if distribution_attribute_value_list[value] > 4:
		distribution_attribute_value_list[value] -= 1
		value_element.text = "%s" % distribution_attribute_value_list[value]
		distribution_attribute_value_list[5] += 1
		remaining_value_label.text = "%s" % distribution_attribute_value_list[5]
	save_attributes()
	send_signal_to_main()

func _on_plus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("../ValueContainer/Value") as Label
	var value = value_element.stat
	if distribution_attribute_value_list[value] < 19 and distribution_attribute_value_list[5] > 0:
		distribution_attribute_value_list[value] += 1
		value_element.text = "%s" % distribution_attribute_value_list[value]
		distribution_attribute_value_list[5] -= 1
		remaining_value_label.text = "%s" % distribution_attribute_value_list[5]
	save_attributes()
	send_signal_to_main()

func _on_TabContainer_tab_changed(_tab:int): 
	clean_up_step()

func send_signal_to_main():
	if distribution_attribute_value_list[5] == 0:
		emit_signal("attributes_selected")
	else:
		emit_signal("attributes_cleared")

onready var distribute_attributes_ui = $"%DistributeAttributesUI"
onready var roll_attributes_ui = $"%RollAttributesUI"

onready var rolling_button = $"%RollingButton"
onready var distribute_button = $"%DistributeButon"

onready var distribute_remaining_points = $"%RemainingPoints"
onready var roll_handle_animator = $"%RollHandleAnimator"

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

onready var roll_container1 = $"%RollContainer1"
onready var roll_container2 = $"%RollContainer2"
onready var roll_container3 = $"%RollContainer3"
onready var roll_container4 = $"%RollContainer4"
onready var roll_container5 = $"%RollContainer5"

onready var roll_containers = [roll_container1,roll_container2, roll_container3, roll_container4, roll_container5,]

onready var distribute_container_list = [
	distribute_agility_container, 
	distribute_perception_container, 
	distribute_character_container, 
	distribute_wits_container, 
	distribute_body_container]

onready var rolling_container_list = [
	agility_container,
	perception_container,
	character_container,
	wits_container,
	body_container
]

onready var new_minus_button_list = [minus_agi_button,
	minus_per_button,
	minus_cha_button,
	minus_wit_button,
	minus_bod_button
	]

onready var new_plus_button_list = [plus_agi_button,
	plus_per_button,
	plus_cha_button,
	plus_wit_button,
	plus_bod_button
	]


onready var new_distribution_attribute_value_list = [4,4,4,4,4,40]
onready var new_rolling_value_list = [0,0,0,0,0,]

enum {DISTRIBUTING_ROLL, REDISTRIBUTTING_ATTRIBUTE, WAITING_FOR_BUTTON_PRESS}
var status = WAITING_FOR_BUTTON_PRESS

func _ready() -> void:
	for container in distribute_container_list:
		var minus = container.get_node("Minus")
		minus.connect("button_up", self, "on_minus_button_up",[minus])
		var plus = container.get_node("Plus")
		plus.connect("button_up", self, "on_plus_button_up",[plus])
	for container in rolling_container_list:
		var selector = container.get_node("Selector")
		selector.connect("button_up", self, "on_selector_button_up",[container])
	for button in roll_containers:
		button.connect("button_up", self, "_on_RollContainer_button_up", [button])

func new_load_step() -> void:
	new_clean_up_step()


func new_clean_up_step() -> void:
	clear_rolls()
	new_distribution_attribute_value_list = [4,4,4,4,4,40]
	new_rolling_value_list = [0,0,0,0,0,]
	update_values_on_ui()

	save_attributes()

	emit_signal("attributes_cleared")

func attribute_value_label(attribute_container_element:Control):
	return attribute_container_element.get_node("AttributeValue/Label")


func attribute_value_labels_list(containers):
	var new_list = []
	for x in containers:
		new_list.append(attribute_value_label(x))
	return new_list


func clear_stats(containers) -> void:
	for value in attribute_value_labels_list(containers):
		value.text = "0"


func clear_rolls() -> void:
	for math in math_list:
		math.bbcode_text = ""


func on_minus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("./../AttributeValue/Label") as Label
	var value = value_element.stat
	if new_distribution_attribute_value_list[value] > 4:
		new_distribution_attribute_value_list[value] -= 1
		new_distribution_attribute_value_list[5] += 1
	update_values_on_ui()
	set_distribution_button_states()
	new_save_attributes()
	send_signal_to_main()

	
func on_plus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("./../AttributeValue/Label") as Label
	var value = value_element.stat
	if new_distribution_attribute_value_list[value] < 19 and new_distribution_attribute_value_list[5] > 0:
		new_distribution_attribute_value_list[value] += 1
		new_distribution_attribute_value_list[5] -= 1
	update_values_on_ui()
	new_save_attributes()
	set_distribution_button_states()
	send_signal_to_main()


func new_save_attributes() -> void:
	var list = []
	if rolling_button.is_pressed():
		list = new_rolling_value_list
	elif distribute_button.is_pressed():
		list = new_distribution_attribute_value_list.slice(0, 4)
	CharacterStats._on_AttributesStep_attributes_chosen(list)


func send_signal_if_all_attributes_set() -> void:
	for attribute in rolling_attribute_value_list:
		if attribute.text == "":
			return
	emit_signal("attributes_selected")


func _on_Button_toggled(_button_pressed:bool):
	new_clean_up_step()
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
		container_list = rolling_container_list
		attribute_list = new_rolling_value_list
	elif distribute_button.is_pressed():
		distribute_remaining_points.get_node("Label").text = "%s" % new_distribution_attribute_value_list[5]
		container_list = distribute_container_list
		attribute_list = new_distribution_attribute_value_list
	for index in range(len(container_list)):
		var element = attribute_value_label(container_list[index])
		element.text = "%s" % attribute_list[index]
	

func on_RollButton_button_up():
	status = WAITING_FOR_BUTTON_PRESS
	new_clean_up_step()
	var final_values_list = []
	for x in 6:
		var result_rolls = _roll_attribute_above_six()
		var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
		final_values_list.append(final_value)
	var smallest_value_index = final_values_list.find(final_values_list.min())	
	final_values_list.pop_at(smallest_value_index)
	for x in range(0, len(final_values_list)):
		var roll = roll_containers[x].get_node("Label")
		roll.text = "%s" % str(final_values_list[x])
	for button in roll_containers:
		button.disabled = false


func set_distribution_button_states():
	for index in len(distribute_container_list):
		var minus = distribute_container_list[index].get_node("Minus")
		var plus = distribute_container_list[index].get_node("Plus")
		if new_distribution_attribute_value_list[5] == 0 or new_distribution_attribute_value_list[index] == 19:
			plus.disabled = true
		else:
			plus.disabled = false
		if new_distribution_attribute_value_list[index] == 4:
			minus.disabled = true
		else:
			minus.disabled = false

func set_rolling_button_states():
	for button in roll_containers:
		if button.get_node("Label").text != "":
			button.disabled = false
		else:
			button.disabled = true
	for container in rolling_container_list:
		var selector = container.get_node("Selector")
		if container.get_node("AttributeValue/Label").text == "0":
			selector.disabled = true
		else:
			selector.disabled = false


func _on_Roll_Attributes_pressed():
	roll_handle_animator.play("Roll")


func _on_RollContainer_button_up(sender_button):
	for container in rolling_container_list:
		var selector = container.get_node("Selector")
		if container.get_node("AttributeValue/Label").text == "0":
			selector.disabled = false
		else:
			selector.disabled = true
	for button in roll_containers:
		if button != sender_button:
			button.disabled = true
	status = DISTRIBUTING_ROLL


func on_selector_button_up(container):
	if status == DISTRIBUTING_ROLL:
		var value = container.get_node("AttributeValue/Label")
		var copied_value = null
		for element in roll_containers:
			if element.disabled == false:
				copied_value = element.get_node("Label").text
				element.get_node("Label").text = ""
		value.text = copied_value
		copied_value = null
		set_rolling_button_states()
		status = WAITING_FOR_BUTTON_PRESS
		return
	if status == WAITING_FOR_BUTTON_PRESS:
		for button in roll_containers:
			button.disabled = true
		for selector_container in rolling_container_list:
			var selector = selector_container.get_node("Selector")
			selector.disabled = false
		container.get_node("Selector").disabled = true
		status = REDISTRIBUTTING_ATTRIBUTE
		return
	if status == REDISTRIBUTTING_ATTRIBUTE:
		var origin_container = null
		for old_container in rolling_container_list:
			if old_container.get_node("Selector").disabled == true:
				origin_container = old_container
		var swapped_node1 = container.get_node("AttributeValue/Label")
		var swapped_node2 = origin_container.get_node("AttributeValue/Label")
		var old_value = swapped_node1.text
		swapped_node1.text = swapped_node2.text
		swapped_node2.text = old_value
		set_rolling_button_states()
		status = WAITING_FOR_BUTTON_PRESS
		return
