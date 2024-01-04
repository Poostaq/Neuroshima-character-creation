extends Node

export var character_name : String
export var ethnicity : String
export var ethnicity_trait : String
export var profession : String
export var profession_trait : String
export var specialization : String
export var specialization_identifier : String

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
#var skill_levels_before_skill_distribution : Dictionary
#var skill_packs : Dictionary
var general_knowledge_names : Array = ["","",""]
var skill_data : Array
var skill_data_before_skill_distribution: Array


func _init() -> void:
	var rows = DatabaseOperations.read_all_skill_packs()
	skill_data = DatabaseOperations.create_skill_packs_from_database_query_result(rows)
	skill_data_before_skill_distribution = DatabaseOperations.create_skill_packs_from_database_query_result(rows)



func get_final_attribute_value(attribute_modifiers: Dictionary) -> int:
	var result = 0
	for key in attribute_modifiers:
		result+=int(attribute_modifiers[key])
	return result

func clear_base_rolls_attributes() -> void:
	for element in attribute_modifiers_dicts:
		element["BaseRoll"] = 0


func _clear_bonus_attribute() -> void:
	for element in attribute_modifiers_dicts:
		element["EthnicityAttributeModifier"] = 0
	attribute_modifier = 0


func clear_specialization() -> void:
	specialization = ""
	specialization_identifier = ""

func set_bonus_attribute(attribute=null) -> void:
	if attribute != null or (attribute <= 4 and attribute >= 0):
		attribute_modifiers_dicts[attribute]["EthnicityAttributeModifier"] = 1

func _on_AttributesStep_attributes_chosen(attribute_list) -> void:
	self.clear_base_rolls_attributes()
	for x in range(0, len(attribute_list)):
		_set_base_roll(x, attribute_list[x])

func _set_base_roll(attribute=null, value=0) -> void:
	if attribute != null or (attribute <= 5 and attribute >= 0):
		attribute_modifiers_dicts[attribute]["BaseRoll"] = value

func _on_ProfessionStep_clear_trait() -> void:
	profession_trait = ""

func _on_ProfessionStep_profession_chosen(chosen_profession) -> void:
	profession = chosen_profession["profession_name"]


func _on_ProfessionStep_trait_chosen(trait_button) -> void:
	profession_trait = trait_button.trait_name


func _on_EthnicityStep_ethnicity_chosen(chosen_ethnicity):
	ethnicity = chosen_ethnicity["ethnicity_name"]


func _on_EthnicityStep_attribute_chosen(bonus_attribute) -> void:
	_clear_bonus_attribute()
	attribute_modifier = bonus_attribute
	set_bonus_attribute(attribute_modifier)


func _on_EthnicityStep_trait_chosen(trait_element) -> void:
	ethnicity_trait = _format_ethnicity_trait_name(trait_element)


func _format_ethnicity_trait_name(trait_button) -> String:
	if trait_button.identifier == "versatility_squared":
		return tr(trait_button.trait_name) +" : \n " + tr(trait_button.secondary_trait)
	else:
		return tr(trait_button.trait_name)

func _on_EthnicityStep_clear_ethnicity() -> void:
	ethnicity = ""
	ethnicity_trait = ""


func _on_EthnicityStep_clear_bonus_attribute() -> void:
	_clear_bonus_attribute()


func _on_ProfessionStep_clear_profession() -> void:
	profession = ""


func _on_specializationStep_specialization_chosen(current_specialization) -> void:
	specialization = current_specialization["specialization_name"]
	specialization_identifier = current_specialization["specialization_identifier"]

#func restore_initial_skill_levels() -> void:
#	CharacterStats.skill_levels = CharacterStats.skill_levels_before_skill_distribution


func get_pack_data(skill_pack: SkillPack, skill_data_object) -> SkillPack:
	var skill_pack_index = 0
	for i in range(0, skill_data_object.size()):
		if skill_data_object[i].identifier == skill_pack.identifier:
			skill_pack_index = i
	return skill_data_object[skill_pack_index]

func duplicate_data(data_copied_from, data_copied_to):
	for index in range(0,len(data_copied_to)):
		data_copied_to[index].duplicate(data_copied_from[index])
