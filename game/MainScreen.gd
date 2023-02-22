extends Control

onready var indicator_active = preload("res://UI_Elements/progress light on.png")
onready var indicator_inactive = preload("res://UI_Elements/progress light off.png")


export (NodePath) onready var back_step = get_node(back_step) as TextureButton
export (NodePath) onready var next_step = get_node(next_step) as TextureButton
export (NodePath) onready var steps_container =  get_node(steps_container) as HBoxContainer
export (NodePath) onready var card_button = get_node(card_button) as TextureButton
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control
export (NodePath) onready var character_stats = get_node(character_stats) as Node

export (NodePath) onready var ethnicity_element = get_node(ethnicity_element) as Control
export (NodePath) onready var profession_element = get_node(profession_element) as Control
export (NodePath) onready var attributes_element = get_node(attributes_element) as Control
export (NodePath) onready var specialisation_element = get_node(specialisation_element) as Control
export (NodePath) onready var distribute_skill_points_element = get_node(distribute_skill_points_element) as Control

export (NodePath) onready var ethnicity_indicator = get_node(ethnicity_indicator) as TextureButton
export (NodePath) onready var profession_indicator = get_node(profession_indicator) as TextureButton
export (NodePath) onready var attributes_indicator = get_node(attributes_indicator) as TextureButton
export (NodePath) onready var specjalization_indicator = get_node(specjalization_indicator) as TextureButton
export (NodePath) onready var skills_indicator = get_node(skills_indicator) as TextureButton
export (NodePath) onready var tricks_indicator = get_node(tricks_indicator) as TextureButton
export (NodePath) onready var diseases_indicator = get_node(diseases_indicator) as TextureButton
export (NodePath) onready var reputation_indicator = get_node(reputation_indicator) as TextureButton
export (NodePath) onready var form_indicator = get_node(form_indicator) as TextureButton
export (NodePath) onready var gear_indicator = get_node(gear_indicator) as TextureButton



var current_step = 0
onready var steps = [
					ethnicity_element,
					profession_element,
					attributes_element,
					specialisation_element,
					distribute_skill_points_element,
]

onready var indicators = [
					ethnicity_indicator,
					profession_indicator,
					attributes_indicator,
					specjalization_indicator,
					skills_indicator,
					tricks_indicator,
					diseases_indicator,
					reputation_indicator,
					form_indicator,
					gear_indicator,
]


func _ready():
	back_step.disabled = true
	next_step.disabled = true
	


func _on_CardButton_button_up():
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _next_step():
	if steps[current_step] == attributes_element:
		attributes_element.save_attributes()
	if current_step == len(steps)-2:
		next_step.disabled = true
	current_step += 1
	back_step.disabled = false
	prepare_step()
	_turn_on_step_indicators()
	_turn_off_screens()
	character_sheet_panel.update_card()
	
	
func _previous_step():
	if steps[current_step] == attributes_element:
		character_stats.clear_base_rolls_attributes()
	if steps[current_step] == specialisation_element:
		character_stats.clear_specialization()
	if current_step == 1:
		back_step.disabled = true
	if current_step == 0:
		print("CANT GO BACK")
	else:
		current_step -= 1
	_disable_next_step()
	prepare_step()
	_turn_off_step_indicators()
	_turn_off_screens()


func _turn_off_screens():
	for s in range(0, steps.size()):
		if s == current_step:
			steps[s].visible = true
			steps[s].mouse_filter = Control.MOUSE_FILTER_PASS
		else:
			steps[s].visible = false


func _turn_on_step_indicators():
	for i in range(0, steps.size()):
		if i == current_step:
			indicators[i].texture_normal = indicator_active


func _turn_off_step_indicators():
	for i in range(0, steps.size()):
		if i == current_step:
			indicators[i+1].texture_normal = indicator_inactive


func _enable_next_step(_argument):
	next_step.disabled = false


func _disable_next_step():
	next_step.disabled = true


func prepare_step():
	if steps[current_step] == distribute_skill_points_element:
		steps[current_step].load_step(character_stats.skill_levels)
	else:
		steps[current_step].load_step()
