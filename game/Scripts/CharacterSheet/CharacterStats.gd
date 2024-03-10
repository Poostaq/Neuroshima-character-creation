extends Node

export var character_name : String
export var ethnicity : String
export var ethnicity_id : String
export var ethnicity_trait : String
export var ethnicity_trait_id : String
export var secondary_trait : String
export var secondary_trait_id : String
export var profession : String
export var profession_id : String
export var profession_trait : String
export var profession_trait_id : String
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
var general_knowledge_names : Array = ["","",""]
var skill_data : Dictionary
var skill_data_before_skill_distribution: Dictionary
var flags: Dictionary
var special_rules: Dictionary
var fame: int
var tricks: Array
var player_id: int
var player_seed: int
var player_seed_state: int

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
	profession_trait_id = ""

func _on_ProfessionStep_profession_chosen(chosen_profession) -> void:
	profession = chosen_profession["profession_name"]
	profession_id = chosen_profession["profession_identifier"]


func _on_ProfessionStep_trait_chosen(trait_button) -> void:
	profession_trait = trait_button.trait_name
	profession_trait_id = trait_button.identifier


func _on_EthnicityStep_ethnicity_chosen(chosen_ethnicity):
	ethnicity = chosen_ethnicity["ethnicity_name"]
	ethnicity_id = chosen_ethnicity["ethnicity_identifier"]


func _on_EthnicityStep_attribute_chosen(bonus_attribute) -> void:
	_clear_bonus_attribute()
	attribute_modifier = bonus_attribute
	set_bonus_attribute(attribute_modifier)


func _on_EthnicityStep_trait_chosen(trait_element) -> void:
	if trait_element.identifier == "versatility_squared":
		secondary_trait = trait_element.secondary_trait
	ethnicity_trait = trait_element.trait_name
	ethnicity_trait_id = trait_element.identifier

func _on_EthnicityStep_clear_ethnicity() -> void:
	ethnicity = ""
	ethnicity_id = ""
	ethnicity_trait = ""
	ethnicity_trait_id = ""


func _on_EthnicityStep_clear_bonus_attribute() -> void:
	_clear_bonus_attribute()


func _on_ProfessionStep_clear_profession() -> void:
	profession = ""
	profession_id = ""


func _on_specializationStep_specialization_chosen(current_specialization) -> void:
	specialization = current_specialization["specialization_name"]
	specialization_identifier = current_specialization["specialization_identifier"]


func get_pack_data(identifier: String, searched_skill_data) -> SkillPack:
	var skill_pack_index = ""
	for key in searched_skill_data.keys():
		if searched_skill_data[key].identifier == identifier:
			skill_pack_index = key
	return searched_skill_data[skill_pack_index]

func find_pack_data(identifier: String) -> SkillPack:
	for pack in skill_data.keys():
		if skill_data[pack].identifier == identifier:
			return skill_data[pack]
	return null

func duplicate_data(data_copied_from, data_copied_to):
	for object in data_copied_to.keys():
		data_copied_to[object].duplicate(data_copied_from[object])

func is_alternative_general_knowledge_active():
	return CharacterStats.flags.has("general_knowledge_alternative") and \
	CharacterStats.flags["general_knowledge_alternative"]

func is_special_rules_ethnicity_applied():
	return CharacterStats.special_rules.has("Ethnicity") and \
	CharacterStats.special_rules["Ethnicity"]

func is_special_rules_profession_applied():
	return CharacterStats.special_rules.has("Profession") and \
	CharacterStats.special_rules["Profession"]

func remove_trick_from_character(trick_id):
	for i in range(0, len(tricks)):
		if tricks[i].trick_id == trick_id:
			tricks.pop_at(i)

func update_attribute_values():
	var attribute_list = DatabaseOperations.read_list_of_attributes_without_any()
	for index in range(0,len(attribute_list)):
		var attribute = attribute_modifiers_dicts[index]
		var value = 0
		for key in attribute:
			value += attribute[key]
		DatabaseOperations.update_attribute_value(player_id, attribute_list[index].trim_suffix ("_name"), value)
	
func get_all_skill_dictionary():
	var skill_dictionary = {}
	for skill_pack in skill_data.keys():
		for skill in skill_data[skill_pack].skill_data:
			skill_dictionary[skill.skill_identifier] = skill.level
	return skill_dictionary
