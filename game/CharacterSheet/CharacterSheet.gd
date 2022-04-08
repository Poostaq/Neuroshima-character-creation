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

onready var agi_modifiers_list = [agi_easy_value,agi_normal_value,agi_problematic_value,agi_hard_value,agi_very_hard_value,agi_fucking_hard_value,agi_luck_value]
onready var per_modifiers_list = [per_easy_value,per_normal_value,per_problematic_value,per_hard_value,per_very_hard_value,per_fucking_hard_value,per_luck_value]
onready var cha_modifiers_list = [cha_easy_value,cha_normal_value,cha_problematic_value,cha_hard_value,cha_very_hard_value,cha_fucking_hard_value,cha_luck_value]
onready var wit_modifiers_list = [wit_easy_value,wit_normal_value,wit_problematic_value,wit_hard_value,wit_very_hard_value,wit_fucking_hard_value,wit_luck_value]
onready var bod_modifiers_list = [bod_easy_value,bod_normal_value,bod_problematic_value,bod_hard_value,bod_very_hard_value,bod_fucking_hard_value,bod_luck_value]


onready var name_element = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var ethnicity_element = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Ethnicity
onready var ethnicity_trait = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/EthnicityTrait
onready var character_stats_element = $CharacterStats

func _ready():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP


func update_values():
	ethnicity_element.bbcode_text = character_stats_element.ethnicity
	ethnicity_trait.bbcode_text = character_stats_element.ethnicity_trait


func update_attribute_values(attributeEnum):
	var value
	match attributeEnum:
		GlobalConstants.attribute.AGI:
			value = get_final_attribute_value(self.character_stats_element.agi_modifiers)
			self.character_stats_element.agi_value = value
			agility_attribute_value.bbcode_text ="[center]%s[/center]" %  value
			fill_attribute_modifiers(value, agi_modifiers_list)
		GlobalConstants.attribute.PER:
			value = get_final_attribute_value(self.character_stats_element.per_modifiers)
			self.character_stats_element.per_value = value
			perception_attribute_value.bbcode_text ="[center]%s[/center]" %  value
			fill_attribute_modifiers(value, per_modifiers_list)
		GlobalConstants.attribute.CHA:
			value = get_final_attribute_value(self.character_stats_element.cha_modifiers)
			self.character_stats_element.cha_value = value
			character_attribute_value.bbcode_text ="[center]%s[/center]" %  value
			fill_attribute_modifiers(value, cha_modifiers_list)
		GlobalConstants.attribute.WIT:
			value = get_final_attribute_value(self.character_stats_element.wit_modifiers)
			self.character_stats_element.wit_value = value
			wits_attribute_value.bbcode_text ="[center]%s[/center]" %  value
			fill_attribute_modifiers(value, wit_modifiers_list)
		GlobalConstants.attribute.BOD:
			value = get_final_attribute_value(self.character_stats_element.bod_modifiers)
			self.character_stats_element.bod_value = value
			body_attribute_value.bbcode_text ="[center]%s[/center]" %  value
			fill_attribute_modifiers(value, bod_modifiers_list)


func get_final_attribute_value(attribute_modifiers :Dictionary):
	var result = 0
	for key in attribute_modifiers:
		result+=attribute_modifiers[key]
	return result


func fill_attribute_modifiers(attribute_value: int, attribute_modifiers_elements: Array):
	attribute_modifiers_elements[0].bbcode_text = return_modifier_value_or_n(attribute_value+2)
	attribute_modifiers_elements[1].bbcode_text = return_modifier_value_or_n(attribute_value)
	attribute_modifiers_elements[2].bbcode_text = return_modifier_value_or_n(attribute_value-2)
	attribute_modifiers_elements[3].bbcode_text = return_modifier_value_or_n(attribute_value-5)
	attribute_modifiers_elements[4].bbcode_text = return_modifier_value_or_n(attribute_value-8)
	attribute_modifiers_elements[5].bbcode_text = return_modifier_value_or_n(attribute_value-11)
	attribute_modifiers_elements[6].bbcode_text = return_modifier_value_or_n(attribute_value-15)


func return_modifier_value_or_n(value):
	if value < 1:
		return "[center]N[/center]"
	return str("[center]%s[/center]" %value)


func set_bonus_attribute(attribute=null):
	#CLEAR PREVIOUS MODIFIER
	self.character_stats_element.agi_modifiers["EthnicityAttributeModifier"] = 0
	self.character_stats_element.per_modifiers["EthnicityAttributeModifier"] = 0
	self.character_stats_element.cha_modifiers["EthnicityAttributeModifier"] = 0
	self.character_stats_element.wit_modifiers["EthnicityAttributeModifier"] = 0
	self.character_stats_element.bod_modifiers["EthnicityAttributeModifier"] = 0
	
	#SET NEW MODIFIER
	if attribute == 0:
		self.character_stats_element.agi_modifiers["EthnicityAttributeModifier"] = 1
#		print("0 AGILITY")
	elif attribute == 1:
		self.character_stats_element.per_modifiers["EthnicityAttributeModifier"] = 1
#		print("1 PERCEPCTION")
	elif attribute == 2:
		self.character_stats_element.cha_modifiers["EthnicityAttributeModifier"] = 1
#		print("2 CHARACTER")
	elif attribute == 3:
		self.character_stats_element.wit_modifiers["EthnicityAttributeModifier"] = 1
#		print("3 WITS")
	elif attribute == 4:
		self.character_stats_element.bod_modifiers["EthnicityAttributeModifier"] = 1
#		print("4 BODY")
	else:
		print("DIDNT MATCH ANYTHING")


func _on_CloseButton_button_up():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_Ethnicity_ethnicity_chosen(trait_button, ethnicity, attribute):
	var trait_name
	if trait_button.trait_name == "Wszechstronność do kwadratu":
		trait_name = trait_button.trait_name +" : " + trait_button.secondary_trait
	else:
		trait_name = trait_button.trait_name
	self.character_stats_element.ethnicity = ethnicity["ethnicity_name"]
	self.character_stats_element.ethnicity_trait = trait_name
	self.set_bonus_attribute(attribute)
	for attr in GlobalConstants.attribute:
		self.update_attribute_values(GlobalConstants.attribute[attr])
	self.update_values()


func _on_Ethnicity_attribute_chosen(bonus_attribute):
	
	self.set_bonus_attribute(bonus_attribute)
	for attr in GlobalConstants.attribute:
		self.update_attribute_values(GlobalConstants.attribute[attr])
#		self.update_attribute_values(ChooseEthnicityStep.ethnicity["attribute_enum"])
#		self.update_attribute_values(CES.ethnicity["attribute_enum"])
