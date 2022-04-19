extends Control

export (NodePath) onready var roll_button = get_node(roll_button) as Button
export (NodePath) onready var math_label = get_node(math_label) as RichTextLabel
export (NodePath) onready var result_label = get_node(result_label) as RichTextLabel
export (NodePath) onready var result_container = get_node(result_container) as HBoxContainer
export (NodePath) onready var roll_button_container = get_node(roll_button_container) as CenterContainer

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

onready var roll_list = [roll1_label,roll2_label,roll3_label, roll4_label, roll5_label]
onready var attribute_value_list = [
	agility_attribute_val,
	perception_attribute_val,
	character_attribute_val,
	wits_attribute_val,
	body_attribute_val
	]

var current_roll = 0

func _ready():
	agility_attribute_val.connect("dropped_data", self, "on_dropped_data")
	perception_attribute_val.connect("dropped_data", self, "on_dropped_data")
	character_attribute_val.connect("dropped_data", self, "on_dropped_data")
	wits_attribute_val.connect("dropped_data", self, "on_dropped_data")
	body_attribute_val.connect("dropped_data", self, "on_dropped_data")

func _on_RollButton_button_up():
	if current_roll == 5:
		current_roll = 0
		roll_button.text = "RZUĆ KOŚĆMI"
		clear_rolls()
		clear_attribute_values()
	var result_rolls = Dices.roll_dice(3, 20)
	var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
	roll_button_container.visible = false
	result_container.visible = true
	math_label.bbcode_text = ("[center] (%s+%s+%s)/3= " % result_rolls)
	result_label.bbcode_text = "[center]%s" % str(final_value)
	set_roll_label(final_value)
	current_roll +=1
	if current_roll == 5:
		roll_button.text = "PRZERZUĆ RZUTY?"

func clear_rolls():
	for roll in roll_list:
		roll.bbcode_text = ""

func clear_attribute_values():
	for attribute in attribute_value_list:
		attribute.bbcode_text = ""
	
func set_roll_label(roll_value):
	roll_list[current_roll].bbcode_text = "[center]%s" % str(roll_value)

func on_dropped_data():
	print("FUNCTION AFTER SIGNAL DROPPED DATA")
	roll_button_container.visible = true
	result_container.visible = false
	result_label.bbcode_text = ""
	math_label.bbcode_text = ""
