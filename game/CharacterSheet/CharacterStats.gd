extends Node

export var character_name : String
export var ethnicity : String
export var ethnicity_trait : String
export var profession : String
export var profession_trait : String
export var specialization : String

export var agi_value : int
export var agi_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var per_value : int
export var per_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var cha_value : int
export var cha_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var wit_value : int
export var wit_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

export var bod_value : int
export var bod_modifiers : Dictionary = {"EthnicityAttributeModifier" : 0, "BaseRoll" : 0}

var attribute_modifiers_dicts = [agi_modifiers, per_modifiers, cha_modifiers, wit_modifiers, bod_modifiers]
var attribute_values_list = [agi_value,per_value,cha_value,wit_value,bod_value]
var attribute_modifier : int
var skill_levels : Dictionary


func _init() -> void:
	var skill_data = DatabaseOperations.read_skills()
	for skill in skill_data:
		skill_levels[skill["skill_name"]] = 0


func get_final_attribute_value(attribute_modifiers : Dictionary):
	var result = 0
	for key in attribute_modifiers:
		result+=attribute_modifiers[key]
	return result

func clear_base_rolls_attributes():
	for element in attribute_modifiers_dicts:
		element["BaseRoll"] = 0


func _clear_bonus_attribute():
	for element in attribute_modifiers_dicts:
		element["EthnicityAttributeModifier"] = 0
	attribute_modifier = 0


func clear_specialization():
	specialization = ""

func set_bonus_attribute(attribute=null):
	if attribute != null or (attribute <= 4 and attribute >= 0):
		attribute_modifiers_dicts[attribute]["EthnicityAttributeModifier"] = 1

func _on_AttributesStep_attributes_chosen(attribute_list):
	self.clear_base_rolls_attributes()
	for x in range(0, len(attribute_list)):
		_set_base_roll(x, attribute_list[x])

func _set_base_roll(attribute=null, value=0):
	if attribute != null or (attribute <= 5 and attribute >= 0):
		attribute_modifiers_dicts[attribute]["BaseRoll"] = value

func _on_ProfessionStep_clear_trait():
	profession_trait = ""

func _on_ProfessionStep_profession_chosen(chosen_profession):
	profession = chosen_profession["profession_name"]


func _on_ProfessionStep_trait_chosen(trait_button):
	profession_trait = trait_button.trait_name


func _on_EthnicityStep_ethnicity_chosen(chosen_ethnicity):
	ethnicity = chosen_ethnicity["ethnicity_name"]


func _on_EthnicityStep_attribute_chosen(bonus_attribute):
	_clear_bonus_attribute()
	attribute_modifier = bonus_attribute
	set_bonus_attribute(attribute_modifier)


func _on_EthnicityStep_trait_chosen(trait_element):
	ethnicity_trait = _format_ethnicity_trait_name(trait_element)


func _format_ethnicity_trait_name(trait_button):
	if trait_button.identifier == "versatility_squared":
		return trait_button.trait_name +" : " + trait_button.secondary_trait
	else:
		return trait_button.trait_name

func _on_EthnicityStep_clear_ethnicity():
	ethnicity = ""
	ethnicity_trait = ""


func _on_EthnicityStep_clear_bonus_attribute():
	_clear_bonus_attribute()


func _on_ProfessionStep_clear_profession():
	profession = ""


func _on_SpecialisationStep_specialization_chosen(current_specialisation):
	specialization = current_specialisation["specialization_name"]
