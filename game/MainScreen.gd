extends Control

signal step_chosen(current_step)


export (NodePath) onready var steps_container =  get_node(steps_container) as HBoxContainer
export (NodePath) onready var card_button = get_node(card_button) as TextureButton
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control
export (NodePath) onready var ethnicity_element = get_node(ethnicity_element) as Control
export (NodePath) onready var profession_element = get_node(profession_element) as Control

var current_step = 0
var steps_list = []
var step = {}

func _ready():
	steps_list = _return_steps_lists()
	print(steps_list)


func _load_step():
	pass

func _on_CardButton_button_up():
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _on_EthnicityStep_button_up():
	ethnicity_element.visible = true
	profession_element.visible = false
	ethnicity_element.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_ProfessionStep_button_up():
	profession_element.visible = true
	ethnicity_element.visible = false
	profession_element.mouse_filter = Control.MOUSE_FILTER_PASS
	

func _on_ProfessionStep_pressed():
	pass # Replace with function body.
#	profession_element


func _return_steps_lists():
	for s in steps_container.get_children():
		steps_list.append(s.get_name())
	print (steps_list)	
	return (steps_list)


func _on_Next_button_up():
	if current_step == len(steps_list)-1:
		print (len(steps_list))
		current_step = 0
		print ("if " + str(current_step))
	else:
		current_step += 1
		print("else " + str(current_step))
		print (len(steps_list))
	_load_step()
	_changed_screen()
	
func _changed_screen():
	pass


func _on_Back_button_up():
	pass # Replace with function body."CenterContainer/VBoxContainer/HBoxContainer/StepsContainer"


func _on_ProfessionStep_toggled(_button_pressed):
	profession_element.visible = true
	ethnicity_element.visible = false
	profession_element.mouse_filter = Control.MOUSE_FILTER_PASS
