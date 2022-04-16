extends Control


export (NodePath) onready var roll_button = get_node(roll_button) as Button
export (NodePath) onready var result_label = get_node(result_label) as RichTextLabel



func _on_RollButton_button_up():
	var result_rolls = Dices.roll_dice(3, 20)
	var final_value = ceil((result_rolls[0]+result_rolls[1]+result_rolls[2])/3.0)
	roll_button.visible = false
	roll_button.mouse_filter = Control.MOUSE_FILTER_STOP
	result_label.visible = true
	result_label.bbcode_text = ("[center] (%s+%s+%s)/3= " % result_rolls) + str(final_value)
