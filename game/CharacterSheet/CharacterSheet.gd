extends Control


#AGILITY
export (NodePath) onready var agility_attribute_value = get_node(agility_attribute_value) as RichTextLabel
export (NodePath) onready var agi_easy_value = get_node(agi_easy_value) as RichTextLabel
export (NodePath) onready var agi_normal_value = get_node(agi_normal_value)as RichTextLabel
export (NodePath) onready var agi_problematic_value = get_node(agi_problematic_value)as RichTextLabel
export (NodePath) onready var agi_hard_value = get_node(agi_hard_value)as RichTextLabel
export (NodePath) onready var agi_very_hard_value = get_node(agi_very_hard_value)as RichTextLabel
export (NodePath) onready var agi_fucking_hard_value = get_node(agi_fucking_hard_value)as RichTextLabel
export (NodePath) onready var agi_luck_value = get_node(agi_luck_value)as RichTextLabel

#PERCEPTION
export (NodePath) onready var perception_attribute_value = get_node(perception_attribute_value) as RichTextLabel
export (NodePath) onready var per_easy_value = get_node(per_easy_value) as RichTextLabel
export (NodePath) onready var per_normal_value = get_node(per_normal_value) as RichTextLabel
export (NodePath) onready var per_problematic_value = get_node(per_problematic_value) as RichTextLabel
export (NodePath) onready var per_hard_value = get_node(per_hard_value) as RichTextLabel
export (NodePath) onready var per_very_hard_value = get_node(per_very_hard_value) as RichTextLabel
export (NodePath) onready var per_fucking_hard_value = get_node(per_fucking_hard_value) as RichTextLabel
export (NodePath) onready var per_luck_value = get_node(per_luck_value) as RichTextLabel

#CHARACTER
export (NodePath) onready var character_attribute_value = get_node(character_attribute_value) as RichTextLabel
export (NodePath) onready var cha_easy_value = get_node(cha_easy_value) as RichTextLabel
export (NodePath) onready var cha_normal_value = get_node(cha_normal_value) as RichTextLabel
export (NodePath) onready var cha_problematic_value = get_node(cha_problematic_value) as RichTextLabel
export (NodePath) onready var cha_hard_value = get_node(cha_hard_value) as RichTextLabel
export (NodePath) onready var cha_very_hard_value = get_node(cha_very_hard_value) as RichTextLabel
export (NodePath) onready var cha_fucking_hard_value = get_node(cha_fucking_hard_value) as RichTextLabel
export (NodePath) onready var cha_luck_value = get_node(cha_luck_value) as RichTextLabel

#WITS
export (NodePath) onready var wits_attribute_value = get_node(wits_attribute_value) as RichTextLabel
export (NodePath) onready var wit_easy_value = get_node(wit_easy_value) as RichTextLabel
export (NodePath) onready var wit_normal_value = get_node(wit_normal_value) as RichTextLabel
export (NodePath) onready var wit_problematic_value = get_node(wit_problematic_value) as RichTextLabel
export (NodePath) onready var wit_hard_value = get_node(wit_hard_value) as RichTextLabel
export (NodePath) onready var wit_very_hard_value = get_node(wit_very_hard_value) as RichTextLabel
export (NodePath) onready var wit_fucking_hard_value = get_node(wit_fucking_hard_value) as RichTextLabel
export (NodePath) onready var wit_luck_value = get_node(wit_luck_value) as RichTextLabel

#BODY
export (NodePath) onready var body_attribute_value = get_node(body_attribute_value) as RichTextLabel
export (NodePath) onready var bod_easy_value = get_node(bod_easy_value) as RichTextLabel
export (NodePath) onready var bod_normal_value = get_node(bod_normal_value) as RichTextLabel
export (NodePath) onready var bod_problematic_value = get_node(bod_problematic_value) as RichTextLabel
export (NodePath) onready var bod_hard_value = get_node(bod_hard_value) as RichTextLabel
export (NodePath) onready var bod_very_hard_value = get_node(bod_very_hard_value) as RichTextLabel
export (NodePath) onready var bod_fucking_hard_value = get_node(bod_fucking_hard_value) as RichTextLabel
export (NodePath) onready var bod_luck_value = get_node(bod_luck_value) as RichTextLabel

onready var agi_modifiers_elements = [agi_easy_value,agi_normal_value,agi_problematic_value,agi_hard_value,agi_very_hard_value,agi_fucking_hard_value,agi_luck_value]
onready var per_modifiers_elements = [per_easy_value,per_normal_value,per_problematic_value,per_hard_value,per_very_hard_value,per_fucking_hard_value,per_luck_value]
onready var cha_modifiers_elements = [cha_easy_value,cha_normal_value,cha_problematic_value,cha_hard_value,cha_very_hard_value,cha_fucking_hard_value,cha_luck_value]
onready var wit_modifiers_elements = [wit_easy_value,wit_normal_value,wit_problematic_value,wit_hard_value,wit_very_hard_value,wit_fucking_hard_value,wit_luck_value]
onready var bod_modifiers_elements = [bod_easy_value,bod_normal_value,bod_problematic_value,bod_hard_value,bod_very_hard_value,bod_fucking_hard_value,bod_luck_value]

onready var attribute_modifiers_elements = [agi_modifiers_elements,per_modifiers_elements,cha_modifiers_elements,wit_modifiers_elements,bod_modifiers_elements]
onready var attribute_value_elements = [agility_attribute_value,perception_attribute_value,character_attribute_value,wits_attribute_value,body_attribute_value]

export (NodePath) onready var name_element = get_node(name_element) as RichTextLabel
export (NodePath) onready var ethnicity_element = get_node(ethnicity_element) as RichTextLabel
export (NodePath) onready var ethnicity_trait_element = get_node(ethnicity_trait_element) as RichTextLabel
export (NodePath) onready var profession_element = get_node(profession_element) as RichTextLabel
export (NodePath) onready var profession_trait_element = get_node(profession_trait_element) as RichTextLabel

onready var character_stats_element = $CharacterStats
onready var db = get_node("/root/DatabaseOperations")


func update_card():
	self._clear_bonus_attribute()
	self._set_bonus_attribute(self.character_stats_element.attribute_modifier)
	for attr in GlobalConstants.attribute:
		self._update_attribute_values(GlobalConstants.attribute[attr])
	self._update_basic_info_values()


func _update_basic_info_values():
	self.ethnicity_element.bbcode_text = self.character_stats_element.ethnicity
	self.ethnicity_trait_element.bbcode_text = self.character_stats_element.ethnicity_trait
	self.profession_element.bbcode_text = self.character_stats_element.profession
	self.profession_trait_element.bbcode_text = self.character_stats_element.profession_trait


func _update_attribute_values(attributeEnum):
	if attributeEnum == GlobalConstants.attribute.ANY:
		return
	var value = _get_final_attribute_value(self.character_stats_element.attribute_modifiers_dicts[attributeEnum])
	self.character_stats_element.attribute_values_list[attributeEnum] = value
	attribute_value_elements[attributeEnum].bbcode_text ="[center]%s[/center]" %  value
	_fill_attribute_modifiers(value, attribute_modifiers_elements[attributeEnum])


func _get_final_attribute_value(attribute_modifiers : Dictionary):
	var result = 0
	for key in attribute_modifiers:
		result+=attribute_modifiers[key]
	return result


func _fill_attribute_modifiers(attribute_value: int, attr_mod_elements: Array):
	var modifiers = DatabaseOperations.read_list_of_modifiers()
	for m in range(0, modifiers.size()):
		attr_mod_elements[m].bbcode_text = _return_modifier_value_or_n(attribute_value + modifiers[m])


func _return_modifier_value_or_n(value):
	if value < 1:
		return "[center]N[/center]"
	return str("[center]%s[/center]" %value)


func _clear_bonus_attribute():
	for element in self.character_stats_element.attribute_modifiers_dicts:
		element["EthnicityAttributeModifier"] = 0


func clear_base_rolls_attributes():
	for element in self.character_stats_element.attribute_modifiers_dicts:
		element["BaseRoll"] = 0


func _set_bonus_attribute(attribute=null):
	if attribute != null or (attribute <= 4 and attribute >= 0):
		self.character_stats_element.attribute_modifiers_dicts[attribute]["EthnicityAttributeModifier"] = 1


func _set_base_roll(attribute=null, value=0):
	if attribute != null or (attribute <= 5 and attribute >= 0):
		self.character_stats_element.attribute_modifiers_dicts[attribute]["BaseRoll"] = value


func _on_CloseButton_button_up():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_EthnicityStep_ethnicity_chosen(ethnicity):
	self.character_stats_element.ethnicity = ethnicity["ethnicity_name"]


func _format_ethnicity_trait_name(trait_button):
	if trait_button.identifier == "versatility_squared":
		return trait_button.trait_name +" : " + trait_button.secondary_trait
	else:
		return trait_button.trait_name


func _on_EthnicityStep_attribute_chosen(bonus_attribute):
	self.character_stats_element.attribute_modifier = bonus_attribute


func _on_EthnicityStep_trait_chosen(trait_element):
	self.character_stats_element.ethnicity_trait = _format_ethnicity_trait_name(trait_element)
	

func _on_EthnicityStep_clear_trait():
	self.character_stats_element.ethnicity_trait = ""
	self._update_basic_info_values()


func _on_ProfessionStep_profession_chosen(profession):
	self.character_stats_element.profession = profession["profession_name"]


func _on_ProfessionStep_trait_chosen(trait_button):
	self.character_stats_element.profession_trait = trait_button.trait_name


func _on_ProfessionStep_clear_trait():
	self.character_stats_element.profession_trait = ""
	self._update_basic_info_values()


func _on_AttributesStep_attributes_chosen(attribute_list):
	self.clear_base_rolls_attributes()
	for x in range(0, len(attribute_list)):
		_set_base_roll(x, attribute_list[x])


func _on_AttributesStep_single_attribute_chosen(attribute, value):
	_set_base_roll(attribute, value)
