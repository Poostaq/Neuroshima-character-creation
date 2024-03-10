extends Control

onready var select_illness = $"%SelectIllness"
onready var rolled_illness_screen = $"%RolledIllnessScreen"
onready var roll_for_illness_screen = $"%RollForIllnessScreen"

var step_name = "illness_step_description"

func _ready():
	pass

func load_step():
	if GlobalVariables.illness_mode == 0:
		select_illness.visible = false
		rolled_illness_screen.visible = false
		roll_for_illness_screen.visible = true
	else:
		select_illness.visible = true
		rolled_illness_screen.visible = false
		roll_for_illness_screen.visible = false
	
func clean_up_step():
	GlobalVariables.global_randomizer.state = CharacterStats.player_seed_state
