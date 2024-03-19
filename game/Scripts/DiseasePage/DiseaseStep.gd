extends Control

signal disease_selected
signal disease_unselected

export(ButtonGroup) var trait_group

onready var select_disease = $"%SelectDisease"
onready var rolled_disease_screen = $"%RolledDiseaseScreen"
onready var roll_for_disease_screen = $"%RollForDiseaseScreen"
onready var rolled_disease_name = $"%RolledDiseaseName"
onready var rolled_disease_description = $"%RolledDiseaseDescription"
onready var rolled_remedy = $"%RolledRemedy"
onready var rolled_first_symptoms = $"%RolledFirstSymptoms"
onready var rolled_acute_condition = $"%RolledAcuteCondition"
onready var rolled_critical_condition = $"%RolledCriticalCondition"
onready var rolled_terminal_condition = $"%RolledTerminalCondition"

onready var disease_list = $"%DiseaseList"
onready var selected_disease_name = $"%SelectedDiseaseName"
onready var selected_disease_description = $"%SelectedDiseaseDescription"
onready var selected_remedy = $"%SelectedRemedy"
onready var selected_first_symptoms = $"%SelectedFirstSymptoms"
onready var selected_acute_condition = $"%SelectedAcuteCondition"
onready var selected_critical_condition = $"%SelectedCriticalCondition"
onready var selected_terminal_condition = $"%SelectedTerminalCondition"

onready var disease_object = preload("res://Scenes/DiseasePage/DiseaseObject.tscn")
onready var selected_condition_list = [selected_first_symptoms,selected_acute_condition,selected_critical_condition,selected_terminal_condition]
onready var rolled_condition_list = [rolled_first_symptoms,rolled_acute_condition,rolled_critical_condition,rolled_terminal_condition]

var current_condition = 0
var step_name = "disease_step_description"

var disease_data_list
var current_disease = 0

func _ready():
	disease_data_list = DatabaseOperations.get_all_disease_data()
	if get_tree().current_scene.name == "DiseaseStep":
		load_step()
		
func load_step():
	if GlobalVariables.disease_mode == 0:
		select_disease.visible = false
		rolled_disease_screen.visible = false
		roll_for_disease_screen.visible = true
	else:
		select_disease.visible = true
		rolled_disease_screen.visible = false
		roll_for_disease_screen.visible = false
		for child in disease_list.get_children():
			child.get_parent().remove_child(child)
			child.queue_free()
		for disease_data in disease_data_list:
			create_new_disease_object(disease_data)
		disease_list.get_children()[0].emit_signal("pressed")
		disease_list.get_children()[0].pressed = true
		
func clean_up_step():
	GlobalVariables.global_randomizer.state = CharacterStats.player_seed_state
	CharacterStats.disease = {}
	emit_signal("disease_unselected")


func create_new_disease_object(disease_data: Dictionary):
	var disease_object_instance = disease_object.instance()
	disease_list.add_child(disease_object_instance)
	disease_object_instance.disease_data = disease_data
	disease_object_instance.set_disease_name()
	disease_object_instance.connect("disease_button_pressed", self, "_on_disease_button_pressed")
	disease_object_instance.get_node(".").set_button_group(trait_group)
	
	
func _on_Button_button_up():
	current_disease = GlobalVariables.global_randomizer.randi_range(1,20)
	var disease_data = disease_data_list[current_disease-1]
	rolled_disease_name.text = disease_data["disease_name"]
	rolled_disease_description.text = disease_data["disease_description"]
	rolled_remedy.text = disease_data["disease_remedy"]
	var first_symptoms_data = {"description": disease_data["disease_first_symptoms"], "penalty": disease_data["disease_first_symptoms_penalties"]}
	_fill_symptom_level(rolled_first_symptoms, first_symptoms_data)
	var acute_condition_data = {"description": disease_data["disease_acute_condition"], "penalty": disease_data["disease_acute_condition_penalties"]}
	_fill_symptom_level(rolled_acute_condition, acute_condition_data)
	var critical_condition_data = {"description": disease_data["disease_cricital_condition"], "penalty": disease_data["disease_cricital_condition_penalties"]}
	_fill_symptom_level(rolled_critical_condition, critical_condition_data)
	var terminal_condition_data = {"description": disease_data["disease_terminal_condition"], "penalty": disease_data["disease_terminal_condition_penalties"]}
	_fill_symptom_level(rolled_terminal_condition, terminal_condition_data)
	rolled_disease_screen.visible = true
	roll_for_disease_screen.visible = false
	CharacterStats.disease = disease_data_list[current_disease]
	emit_signal("disease_selected")


func _on_disease_button_pressed(disease_data):
	selected_disease_name.text = disease_data["disease_name"]
	selected_disease_description.text = disease_data["disease_description"]
	selected_remedy.text = disease_data["disease_remedy"]
	var first_symptoms_data = {"description": disease_data["disease_first_symptoms"], "penalty": disease_data["disease_first_symptoms_penalties"]}
	_fill_symptom_level(selected_first_symptoms, first_symptoms_data)
	var acute_condition_data = {"description": disease_data["disease_acute_condition"], "penalty": disease_data["disease_acute_condition_penalties"]}
	_fill_symptom_level(selected_acute_condition, acute_condition_data)
	var critical_condition_data = {"description": disease_data["disease_cricital_condition"], "penalty": disease_data["disease_cricital_condition_penalties"]}
	_fill_symptom_level(selected_critical_condition, critical_condition_data)
	var terminal_condition_data = {"description": disease_data["disease_terminal_condition"], "penalty": disease_data["disease_terminal_condition_penalties"]}
	_fill_symptom_level(selected_terminal_condition, terminal_condition_data)
	emit_signal("disease_unselected")


func _fill_symptom_level(symptom_object: TextureRect, disease_data):
	var description = symptom_object.get_node("Description")
	var penalty = symptom_object.get_node("Penalty")
	description.text = disease_data["description"]
	penalty.text = disease_data["penalty"]
	

func _on_LowerConditionLevel_button_up():
	if current_condition == 0:
		current_condition = 3
	else:
		current_condition -= 1
	_show_current_condition_level(rolled_condition_list)


func _on_HigherConditionLevel_button_up():
	if current_condition == 3:
		current_condition = 0
	else:
		current_condition += 1
	_show_current_condition_level(rolled_condition_list)


func _on_SelectedLowerConditionLevel_pressed():
	if current_condition == 0:
		current_condition = 3
	else:
		current_condition -= 1
	_show_current_condition_level(selected_condition_list)


func _on_SelectedHigherConditionLevel_pressed():
	if current_condition == 3:
		current_condition = 0
	else:
		current_condition += 1
	_show_current_condition_level(selected_condition_list)


func _show_current_condition_level(condition_list):
	for index in range(0,len(condition_list)):
		if index == current_condition:
			condition_list[index].visible = true
		else:
			condition_list[index].visible = false


func _on_Select_pressed():
	CharacterStats.disease = disease_data_list[current_disease]
	emit_signal("disease_selected")
