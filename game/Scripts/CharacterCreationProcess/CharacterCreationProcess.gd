extends Control

signal back_to_main_menu


onready var indicator_active = preload("res://UI_Elements/progressLightOn.png")
onready var indicator_inactive = preload("res://UI_Elements/progressLightOff.png")


export (NodePath) onready var steps_container =  get_node(steps_container) as HBoxContainer
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control

onready var back_step = $"%BackStepButton"
onready var next_step = $"%NextStepButton"
onready var ethnicity_step = $"%EthnicityStep"
onready var profession_step = $"%ProfessionStep"
onready var attributes_step = $"%AttributesStep"
onready var specialization_step = $"%SpecializationStep"
onready var skill_points_step = $"%SkillPointsStep"
onready var tricks_step = $"%TricksStep"


onready var ethnicity_indicator = $"%EthnicityIndicator"
onready var profession_indicator = $"%ProfessionIndicator"
onready var attributes_indicator = $"%AttributesIndicator"
onready var specialization_indicator = $"%SpecializationIndicator"
onready var skills_indicator = $"%SkillsIndicator"
onready var tricks_indicator = $"%TricksIndicator"
onready var diseases_indicator = $"%DiseasesIndicator"
onready var reputation_indicator = $"%ReputationIndicator"
onready var form_indicator = $"%FormIndicator"
onready var gear_indicator = $"%GearIndicator"



export var current_step = 0
onready var steps = [
					ethnicity_step,
					profession_step,
					attributes_step,
					specialization_step,
					skill_points_step,
					tricks_step,
]

onready var indicators = [
					ethnicity_indicator,
					profession_indicator,
					attributes_indicator,
					specialization_indicator,
					skills_indicator,
					tricks_indicator,
					diseases_indicator,
					reputation_indicator,
					form_indicator,
					gear_indicator,
]


func _ready() -> void:
	next_step.disabled = true
	steps[current_step].load_step()
	


func _on_CardButton_button_up() -> void:
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _next_step() -> void:
	if steps[current_step] == attributes_step:
		attributes_step.save_attributes()
	next_step.disabled = true
	current_step += 1
	back_step.disabled = false
	steps[current_step].load_step()
	_turn_on_step_indicators()
	_show_current_screen()
	character_sheet_panel.update_card()
	
	
func _previous_step() -> void:
	steps[current_step].clean_up_step()
	next_step.disabled = false
	if current_step == 0:
		emit_signal("back_to_main_menu")
	else:
		current_step -= 1
	_turn_off_step_indicators()
	_show_current_screen()
	character_sheet_panel.update_card()


func _show_current_screen() -> void:
	for s in range(0, steps.size()):
		if s == current_step:
			steps[s].visible = true
			steps[s].mouse_filter = Control.MOUSE_FILTER_PASS
		else:
			steps[s].visible = false


func _turn_on_step_indicators() -> void:
	for i in range(0, steps.size()):
		if i == current_step:
			indicators[i].texture_normal = indicator_active


func _turn_off_step_indicators() -> void:
	for i in range(0, steps.size()):
		if i == current_step:
			indicators[i+1].texture_normal = indicator_inactive


func _enable_next_step() -> void:
	next_step.disabled = false


func _disable_next_step() -> void:
	next_step.disabled = true
