extends Control

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
onready var steps = [
					ethnicity_element,
					profession_element,
					attributes_element,
					specjalization_element,
					skills_element,
					tricks_element,
					seven_element,
					eight_element,
					nice_element,
					ten_element
]

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
		print("END")
	else:
		current_step += 1
	_screen_change()
	
	
func _on_Back_button_up():
	if current_step == 0:
		print("CANT GO BACK")
	else:
		current_step -= 1
	_screen_change()


func _screen_change():
	match current_step :
		0:	_on_EthnicityStep_button_up()	
		1:	_on_ProfessionStep_button_up()
		2:	_on_AttributesStep_button_up() 
		3:	_on_SpecialisationStep_button_up()
		4:	_on_SkillsStep_button_up()
		5:	_on_TricksStep_button_up()
		6:	_on_TextureButton7_button_up()
		7:	_on_TextureButton8_button_up()
		8:	_on_TextureButton9_button_up()
		9:	_on_TextureButton10_button_up()


func _on_EthnicityStep_button_up():
	character_sheet_panel.update_card()
	profession_element.visible = false
	ethnicity_element.visible = true
	ethnicity_element.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_ProfessionStep_button_up():
	character_sheet_panel.update_card()
	ethnicity_element.visible = false
	profession_element.visible = true
	profession_element.mouse_filter = Control.MOUSE_FILTER_PASS
	"CenterContainer/VBoxContainer/HBoxContainer/StepsContainer/ProfessionStep"


func _on_AttributesStep_button_up():
	print("ATTRIBUTES SCREEN IN PROGRESS")
	_turn_off_screens()


func _on_SpecialisationStep_button_up():
	print("SPECJALIZATION SCREEN IN PROGRESS")
	_turn_off_screens()


func _on_SkillsStep_button_up():
	print("SKILLS SCREEN IN PROGRESS")
	_turn_off_screens()


func _on_TricksStep_button_up():
	print("TRICKS SCREEN IN PROGRESS")
	_turn_off_screens()
	
	
func _on_TextureButton7_button_up():
	print("7 SCREEN IN PROGRESS")
	_turn_off_screens()
	
	
func _on_TextureButton8_button_up():
	print("8 SCREEN IN PROGRESS")
	_turn_off_screens()
	
	
func _on_TextureButton9_button_up():
	print("9 SCREEN IN PROGRESS")
	_turn_off_screens()
	
	
func _on_TextureButton10_button_up():
	print("10 SCREEN IN PROGRESS")	
	_turn_off_screens()
	

func _turn_off_screens():
	steps[0].visible = false
	steps[1].visible = false
#	attributes_element.visible = false
#	specjalization_element.visible = false
#	skills_element.visible = false
#	tricks_element.visible = false
#	seven_element.visible = false
#	eight_element.visible = false
#	nice_element.visible = false
#	ten_element.visible = false
	
	
