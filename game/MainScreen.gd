extends Control

onready var indicator_active = preload("res://UI_Elements/progress light on.png")
onready var indicator_inactive = preload("res://UI_Elements/progress light off.png")


export (NodePath) onready var back_step = get_node(back_step) as TextureButton
export (NodePath) onready var next_step = get_node(next_step) as TextureButton
export (NodePath) onready var steps_container =  get_node(steps_container) as HBoxContainer
export (NodePath) onready var card_button = get_node(card_button) as TextureButton
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control


onready var ethnicity_step = $"%EthnicityStep"
onready var profession_step = $"%ProfessionStep"
onready var attributes_step = $"%AttributesStep"
onready var specialization_step = $"%SpecializationStep"
onready var skill_points_step = $"%SkillPointsStep"
onready var dummy_step = $"%DummyStep"


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



var current_step = 0
onready var steps = [
					ethnicity_step,
					profession_step,
					attributes_step,
					specialization_step,
					skill_points_step,
					dummy_step,
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
	back_step.disabled = true
	next_step.disabled = true
	


func _on_CardButton_button_up() -> void:
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _next_step() -> void:
	if steps[current_step] == attributes_step:
		attributes_step.save_attributes()
	if current_step == len(steps)-2:
		next_step.disabled = true
	current_step += 1
	back_step.disabled = false
	steps[current_step].load_step()
	_turn_on_step_indicators()
	_turn_off_screens()
	character_sheet_panel.update_card()
	
	
func _previous_step() -> void:
	if steps[current_step] == attributes_step:
		CharacterStats.clear_base_rolls_attributes()
	if steps[current_step] == specialization_step:
		CharacterStats.clear_specialization()
	if steps[current_step] == skill_points_step:
		CharacterStats.restore_initial_skill_levels()
	if current_step == 1:
		back_step.disabled = true
	if current_step == 0:
		print("CANT GO BACK")
	else:
		current_step -= 1
	_disable_next_step()
	steps[current_step].load_step()
	_turn_off_step_indicators()
	_turn_off_screens()


func _turn_off_screens() -> void:
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


func _enable_next_step(_argument) -> void:
	next_step.disabled = false


func _disable_next_step() -> void:
	next_step.disabled = true


