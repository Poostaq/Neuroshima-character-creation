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

onready var roll_list = [roll1_label,roll2_label,roll3_label, roll4_label, roll5_label]

var current_roll = 0

func _on_RollButton_button_up():
	var result_rolls = Dices.roll_dice(3, 20)
	var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
	roll_button_container.visible = false
	result_container.visible = true
	math_label.bbcode_text = ("[center] (%s+%s+%s)/3= " % result_rolls)
	result_label.bbcode_text = "[center]%s" % str(final_value)
	set_roll_label(final_value)
	

func set_roll_label(roll_value):
	roll_list[current_roll].bbcode_text = "[center]%s" % str(roll_value)
