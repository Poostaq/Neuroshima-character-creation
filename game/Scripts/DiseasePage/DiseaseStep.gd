extends Control

onready var select_disease = $"%SelectDisease"
onready var rolled_disease_screen = $"%RolledDiseaseScreen"
onready var roll_for_disease_screen = $"%RollForDiseaseScreen"
onready var disease_name = $"%DiseaseName"
onready var disease_description = $"%DiseaseDescription"
onready var first_symptoms = $"%FirstSymptoms"
onready var acute_condition = $"%AcuteCondition"
onready var critical_condition = $"%CriticalCondition"
onready var terminal_condition = $"%TerminalCondition"
onready var remedy = $"%Remedy"

var step_name = "disease_step_description"

var list_of_disease
var current_disease = 0

func _ready():
	list_of_disease = DatabaseOperations.get_all_disease_data()

func load_step():
	if GlobalVariables.disease_mode == 0:
		select_disease.visible = false
		rolled_disease_screen.visible = false
		roll_for_disease_screen.visible = true
	else:
		select_disease.visible = true
		rolled_disease_screen.visible = false
		roll_for_disease_screen.visible = false
	
func clean_up_step():
	GlobalVariables.global_randomizer.state = CharacterStats.player_seed_state


func _on_Button_button_up():
	current_disease = GlobalVariables.global_randomizer.randi_range(1,20)
	var disease_data = list_of_disease[current_disease-1]
	disease_name.text = disease_data["disease_name"]
	disease_description.text = disease_data["disease_description"]
	remedy.text = disease_data["disease_remedy"]
	var first_symptoms_data = {"description": disease_data["disease_first_symptoms"], "penalty": disease_data["disease_first_symptoms_penalties"]}
	_fill_symptom_level(first_symptoms, first_symptoms_data)
	var acute_condition_data = {"description": disease_data["disease_acute_condition"], "penalty": disease_data["disease_acute_condition_penalties"]}
	_fill_symptom_level(acute_condition, acute_condition_data)
	var critical_condition_data = {"description": disease_data["disease_cricital_condition"], "penalty": disease_data["disease_cricital_condition_penalties"]}
	_fill_symptom_level(critical_condition, critical_condition_data)
	var terminal_condition_data = {"description": disease_data["disease_terminal_condition"], "penalty": disease_data["disease_terminal_condition_penalties"]}
	_fill_symptom_level(terminal_condition, terminal_condition_data)
	rolled_disease_screen.visible = true
	roll_for_disease_screen.visible = false

func _fill_symptom_level(symptom_object: TextureRect, disease_data):
	var description = symptom_object.get_node("Description")
	var penalty = symptom_object.get_node("Penalty")
	description.text = disease_data["description"]
	penalty.text = disease_data["penalty"]
	
	
	
	
