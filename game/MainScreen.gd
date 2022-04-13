extends Control

#signal step_chosen(current_step)


export (NodePath) onready var steps_container =  get_node(steps_container) as HBoxContainer
export (NodePath) onready var card_button = get_node(card_button) as TextureButton
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control
export (NodePath) onready var ethnicity_element = get_node(ethnicity_element) as Control
export (NodePath) onready var profession_element = get_node(profession_element) as Control
export (NodePath) onready var attributes_element = get_node(attributes_element) as Control
export (NodePath) onready var specjalization_element = get_node(specjalization_element) as Control
export (NodePath) onready var skills_element = get_node(skills_element) as Control
export (NodePath) onready var tricks_element = get_node(tricks_element) as Control
export (NodePath) onready var seven_element = get_node(seven_element) as Control
export (NodePath) onready var eight_element = get_node(eight_element) as Control
export (NodePath) onready var nice_element = get_node(nice_element) as Control
export (NodePath) onready var ten_element = get_node(ten_element) as Control

var current_step = 0
var steps_list = []
var step = {}
var steps = [ethnicity_element,profession_element]

func _ready():
	steps_list = _return_steps_lists()


func _on_CardButton_button_up():
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _return_steps_lists():
	for s in steps_container.get_children():
		steps_list.append(s.get_name())
	return (steps_list)


func _on_Next_button_up():
	if current_step == len(steps_list)-1:
		current_step = 0
	else:
		current_step += 1
	_screen_change()
	
	
func _on_Back_button_up():
	if current_step == 0:
		current_step = len(steps_list)-1
	else:
		current_step -= 1
	_screen_change()


func _screen_change():
	if  current_step == 0:
		_on_EthnicityStep_button_up()
		print("ETHNICITY SCREEN")
	elif current_step == 1:
		_on_ProfessionStep_button_up()
		print("PROFESSION SCREEN")
	elif  current_step == 2:
		_on_AttributesStep_button_up()
		print("ATTRIBUTES SCREEN IN PROGRESS")
	elif  current_step == 3:
		_on_SpecialisationStep_button_up()
		print("SPECJALIZATION SCREEN IN PROGRESS")
	elif  current_step == 4:
		_on_SkillsStep_button_up()
		print("SKILLS SCREEN IN PROGRESS")
	elif  current_step == 5:
		_on_TricksStep_button_up()
		print("TRICKS SCREEN IN PROGRESS")
	elif  current_step == 6:
		_on_TextureButton7_button_up()
		print("7 SCREEN IN PROGRESS")
	elif  current_step == 7:
		_on_TextureButton8_button_up()
		print("8 SCREEN IN PROGRESS")
	elif  current_step == 8:
		_on_TextureButton9_button_up()
		print("9 SCREEN IN PROGRESS")
	elif  current_step == 9:
		_on_TextureButton10_button_up()
		print("10 SCREEN IN PROGRESS")
	

func _on_ProfessionStep_toggled(_button_pressed):
	profession_element.visible = true
	ethnicity_element.visible = false
	profession_element.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_EthnicityStep_button_up():
	_turn_off_screens()
	ethnicity_element.visible = true
	ethnicity_element.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_ProfessionStep_button_up():
	_turn_off_screens()
	profession_element.visible = true
	profession_element.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_AttributesStep_button_up():
	_turn_off_screens()


func _on_SpecialisationStep_button_up():
	_turn_off_screens()


func _on_SkillsStep_button_up():
	_turn_off_screens()


func _on_TricksStep_button_up():
	_turn_off_screens()


func _on_TextureButton7_button_up():
	_turn_off_screens()


func _on_TextureButton8_button_up():
	_turn_off_screens()


func _on_TextureButton9_button_up():
	_turn_off_screens()


func _on_TextureButton10_button_up():
	_turn_off_screens()


func _turn_off_screens():
	ethnicity_element.visible = false
	profession_element.visible = false
	attributes_element.visible = false
	specjalization_element.visible = false
	skills_element.visible = false
	tricks_element.visible = false
	seven_element.visible = false
	eight_element.visible = false
	nice_element.visible = false
	ten_element.visible = false
	

