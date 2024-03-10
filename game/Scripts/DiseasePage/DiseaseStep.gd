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
	var current_disease = GlobalVariables.global_randomizer.randi_range(1,20)
	disease_name.text = list_of_disease[current_disease]["disease"]
	rolled_disease_screen.visible = true
	roll_for_disease_screen.visible = false

func _fill_symptom_level(symptom_object: TextureRect, disease_data):
	var description = symptom_object.get_node("Description")
	var penalty = symptom_object.get_node("Penalty")
	description.text = disease_data["description"]
	penalty.text = disease_data["penalty"]
	
	
	
	
