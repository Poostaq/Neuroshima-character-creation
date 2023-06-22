extends Control

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
onready var distribution_attribute_value_list = [4,
	4,
	4,
	4,
	4,
	40
	]




var current_roll = 0


func _ready() -> void:
	for button in minus_button_list:
		button.connect("button_up", self, "_on_minus_button_up",[button])
	for button in plus_button_list:
		button.connect("button_up", self, "_on_plus_button_up",[button])


func load_step() -> void:
	pass

func clean_up_step() -> void:
	_clear_rolls()
	_clear_attribute_values()
	_clear_math()
	distribution_attribute_value_list = [4,
	4,
	4,
	4,
	4,
	40
	]
	for index in range(0,len(distribution_attribute_value_element_list)):
		distribution_attribute_value_element_list[index].text = str(distribution_attribute_value_list[index])
	remaining_value_label.text = str(distribution_attribute_value_list[5])
	save_attributes()

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

func _on_plus_button_up(button : BaseButton) -> void:
	var value_element = button.get_node("../ValueContainer/Value") as Label
	var value = value_element.stat
	if distribution_attribute_value_list[value] < 19 and distribution_attribute_value_list[5] > 0:
		distribution_attribute_value_list[value] += 1
		value_element.text = "%s" % distribution_attribute_value_list[value]
		distribution_attribute_value_list[5] -= 1
		remaining_value_label.text = "%s" % distribution_attribute_value_list[5]
	save_attributes()

func _on_TabContainer_tab_changed(_tab:int): 
	clean_up_step()
