extends Control

onready var cardButton = $CardButton
onready var characterSheetPanel = $CharacterSheet
onready var ethnicityElement = $CenterContainer/VBoxContainer/StepContainer/Ethnicity

onready var database = get_node("/root/DatabaseOperations")

func _ready():
	pass
	
func _on_CardButton_button_up():
	characterSheetPanel.visible = true
	characterSheetPanel.mouse_filter = Control.MOUSE_FILTER_PASS


#func _on_Ethnicity_ethnicity_chosen(traitID):
#	var traitData = _get_ethnicity_trait_data(traitID, "TraitName")
#	var ethnicityName = ethnicityElement.ethnicities[ethnicityElement.current_ethnicity]["Name"]
#	characterSheetPanel.characterStats.set("Ethnicity", ethnicityName)
#	characterSheetPanel.characterStats.set("EthnicityTrait", traitData)
#	characterSheetPanel.updateValues()
#
#func _get_ethnicity_trait_data(traitID, requestedTraitData):
#	var traitData: String
#	var ethnicityTraits = ethnicityElement.ethnicities[ethnicityElement.current_ethnicity]["Traits"]
#	for trait in ethnicityTraits:
#		if trait["ID"] == traitID:
#			 traitData = trait[requestedTraitData]
#	if traitData != null:
#		return traitData
#	else:
#		print("NO SUCH DATA FOR TRAIT")
