extends Control

onready var indicator_active = preload("res://UI_Elements/complete progress indicator.png")
onready var indicator_inactive = preload("res://UI_Elements/empty progress indicator.png")


export (NodePath) onready var back_step = get_node(back_step) as TextureButton
export (NodePath) onready var next_step = get_node(next_step) as TextureButton
export (NodePath) onready var steps_container =  get_node(steps_container) as HBoxContainer
export (NodePath) onready var card_button = get_node(card_button) as TextureButton
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control
export (NodePath) onready var ethnicity_element = get_node(ethnicity_element) as Control
export (NodePath) onready var profession_element = get_node(profession_element) as Control
export (NodePath) onready var ethnicity_button = get_node(ethnicity_button) as TextureButton
export (NodePath) onready var profession_button = get_node(profession_button) as TextureButton
export (NodePath) onready var attributes_button = get_node(attributes_button) as TextureButton
export (NodePath) onready var specjalization_button = get_node(specjalization_button) as TextureButton
export (NodePath) onready var skills_button = get_node(skills_button) as TextureButton
export (NodePath) onready var tricks_button = get_node(tricks_button) as TextureButton
export (NodePath) onready var diseases_button = get_node(diseases_button) as TextureButton
export (NodePath) onready var reputation_button = get_node(reputation_button) as TextureButton
export (NodePath) onready var form_button = get_node(form_button) as TextureButton
export (NodePath) onready var gear_button = get_node(gear_button) as TextureButton
export (NodePath) onready var choose_profession_step = get_node(choose_profession_step) as Control


var current_step = 0
onready var steps = [
					ethnicity_element
					,profession_element
]

onready var buttons = [
					ethnicity_button
					,profession_button
]


func _on_CardButton_button_up():
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _next_step():
	if current_step == len(steps)-1:
		print("The End")
	else:
		current_step += 1
	back_step.disabled = false
	match current_step :
		0:	_EthnicityStep()	
		1:	_ProfessionStep()
	_turn_on_step_buttons()
	_turn_off_screens()	
	character_sheet_panel.update_card()
	
	
func _previous_step():
	if current_step == 0:
		print("CANT GO BACK")
	else:
		current_step -= 1
	next_step.disabled = false
	match current_step :
		0:	_EthnicityStep()	
		1:	_ProfessionStep()
	_turn_off_step_buttons()
	_turn_off_screens()	


func _EthnicityStep():
	_turn_off_screens()
	back_step.disabled = true
	

func _ProfessionStep():
	next_step.disabled = true
	choose_profession_step._load_profession_screen()


func _turn_off_screens():
	for s in range(0, steps.size()):
		if s == current_step:
			steps[s].visible = true
			steps[s].mouse_filter = Control.MOUSE_FILTER_PASS
		else:
			steps[s].visible = false


func _turn_on_step_buttons():
	for b in range(0, steps.size()):
		if b == current_step:
			buttons[b].texture_normal = indicator_active


func _turn_off_step_buttons():
	for b in range(0, steps.size()):
		if b == current_step:
			buttons[b+1].texture_normal = indicator_inactive
