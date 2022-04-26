extends Control

signal attributes_chosen(attribute_list)

export (NodePath) onready var roll_button = get_node(roll_button) as Button
export (NodePath) onready var math_label = get_node(math_label) as RichTextLabel
export (NodePath) onready var result_label = get_node(result_label) as RichTextLabel
export (NodePath) onready var result_container = get_node(result_container) as HBoxContainer
export (NodePath) onready var roll_button_container = get_node(roll_button_container) as CenterContainer

export (NodePath) onready var math1_label = get_node(math1_label) as RichTextLabel
export (NodePath) onready var math2_label = get_node(math2_label) as RichTextLabel
export (NodePath) onready var math3_label = get_node(math3_label) as RichTextLabel
export (NodePath) onready var math4_label = get_node(math4_label) as RichTextLabel
export (NodePath) onready var math5_label = get_node(math5_label) as RichTextLabel

export (NodePath) onready var roll1_label = get_node(roll1_label) as RichTextLabel
export (NodePath) onready var roll2_label = get_node(roll2_label) as RichTextLabel
export (NodePath) onready var roll3_label = get_node(roll3_label) as RichTextLabel
export (NodePath) onready var roll4_label = get_node(roll4_label) as RichTextLabel
export (NodePath) onready var roll5_label = get_node(roll5_label) as RichTextLabel

export (NodePath) onready var agility_attribute_val = get_node(agility_attribute_val) as RichTextLabel
export (NodePath) onready var perception_attribute_val = get_node(perception_attribute_val) as RichTextLabel
export (NodePath) onready var character_attribute_val = get_node(character_attribute_val) as RichTextLabel
export (NodePath) onready var wits_attribute_val = get_node(wits_attribute_val) as RichTextLabel
export (NodePath) onready var body_attribute_val = get_node(body_attribute_val) as RichTextLabel

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

export (NodePath) onready var agi_value_label = get_node(agi_value_label) as BaseButton
export (NodePath) onready var per_value_label = get_node(per_value_label) as BaseButton
export (NodePath) onready var cha_value_label = get_node(cha_value_label) as BaseButton
export (NodePath) onready var wit_value_label = get_node(wit_value_label) as BaseButton
export (NodePath) onready var bod_value_label = get_node(bod_value_label) as BaseButton

export (NodePath) onready var tab_container = get_node(tab_container) as TabContainer


export (NodePath) onready var remaining_value_label = get_node(remaining_value_label) as RichTextLabel

onready var math_list = [math1_label,math2_label,math3_label,math4_label,math5_label]
onready var roll_list = [roll1_label,roll2_label,roll3_label,roll4_label,roll5_label]
onready var attribute_value_list = [
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
onready var value_label_list = [4,
	4,
	4,
	4,
	4,
	40
	]

var current_roll = 0

func _ready():
	agility_attribute_val.connect("dropped_data", self, "on_dropped_data")
	perception_attribute_val.connect("dropped_data", self, "on_dropped_data")
	character_attribute_val.connect("dropped_data", self, "on_dropped_data")
	wits_attribute_val.connect("dropped_data", self, "on_dropped_data")
	body_attribute_val.connect("dropped_data", self, "on_dropped_data")
	for button in minus_button_list:
		button.connect("button_up", self, "_on_minus_button_up",[button])
	for button in plus_button_list:
		button.connect("button_up", self, "_on_plus_button_up",[button])

func load_step():
	pass

func save_attributes():
	var list = []
	if tab_container.current_tab == 0:
		list = [
			int(agility_attribute_val.text),
			int(perception_attribute_val.text),
			int(character_attribute_val.text),
			int(wits_attribute_val.text),
			int(body_attribute_val.text),
		]
		print(list)
	elif tab_container.current_tab == 1:
		list =  value_label_list.slice(0, 4)
		print(list)
	emit_signal("attributes_chosen", list)

func _on_RollButton_button_up():
	_clear_rolls()
	_clear_attribute_values()
	for x in 5:
		var result_rolls = _roll_attribute_above_six()
		var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
		math_list[x].bbcode_text = ("[center] (%s+%s+%s)/3= " % result_rolls) + \
		"%s" % str(final_value)
		roll_list[x].bbcode_text = "[center]%s" % str(final_value)
	
func _roll_attribute_above_six():
	var average = 0
	var results = []
	while average <= 6:
		results = Dices.roll_dice(3, 20)
		average = ceil((results[0]+results[1]+results[2])/3.0)
	return results

func _clear_rolls():
	for roll in roll_list:
		roll.bbcode_text = ""

func _clear_attribute_values():
	for attribute in attribute_value_list:
		attribute.bbcode_text = ""
	
func set_roll_label(roll_value):
	roll_list[current_roll].bbcode_text = "[center]%s" % str(roll_value)

func on_dropped_data():
	result_label.bbcode_text = ""
	math_label.bbcode_text = ""
	

func _on_minus_button_up(button : BaseButton):
	var value_element = button.get_node("../ValueContainer/Value") as RichTextLabel
	var value = value_element.stat
	if value_label_list[value] > 4:
		value_label_list[value] -= 1
		value_element.bbcode_text = "[center]%s" % value_label_list[value]
		value_label_list[5] += 1
		remaining_value_label.bbcode_text = "[center]%s" % value_label_list[5]

func _on_plus_button_up(button : BaseButton):
	var value_element = button.get_node("../ValueContainer/Value") as RichTextLabel
	var value = value_element.stat
	if value_label_list[value] < 19 and value_label_list[5] > 0:
		value_label_list[value] += 1
		value_element.bbcode_text = "[center]%s" % value_label_list[value]
		value_label_list[5] -= 1
		remaining_value_label.bbcode_text = "[center]%s" % value_label_list[5]
	


#func _on_TabContainer_tab_changed(tab):
#	if tab_container.current_tab == 0:
#		for x in range(0, len(attribute_value_list)):
#			value_label_list[x] = 
#	elif tab_container.current_tab == 1:
