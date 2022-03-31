extends Control

onready var Name = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Name
onready var Ethnicity = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Ethnicity
onready var EthnicityTrait = $PanelContainer/MarginContainer/ScrollContainer/TextureRect/Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/EthnicityTrait
onready var characterStats = $CharacterStats

#AGILITY
export (NodePath) onready var AgilityAttributeValue = get_node(AgilityAttributeValue) as RichTextLabel
export (NodePath) onready var AgiEasyValue = get_node(AgiEasyValue) as RichTextLabel
export (NodePath) onready var AgiNormalValue = get_node(AgiNormalValue)as RichTextLabel
export (NodePath) onready var AgiProblematicValue = get_node(AgiProblematicValue)as RichTextLabel
export (NodePath) onready var AgiHardValue = get_node(AgiHardValue)as RichTextLabel
export (NodePath) onready var AgiVeryHardValue = get_node(AgiVeryHardValue)as RichTextLabel
export (NodePath) onready var AgiFuckingHardValue = get_node(AgiFuckingHardValue)as RichTextLabel
export (NodePath) onready var AgiLuckValue = get_node(AgiLuckValue)as RichTextLabel
onready var AgiModifiersList = [AgiEasyValue,AgiNormalValue,AgiProblematicValue,AgiHardValue,AgiVeryHardValue,AgiFuckingHardValue,AgiLuckValue]

#PERCEPTION
export (NodePath) onready var PerceptionAttributeValue = get_node(PerceptionAttributeValue) as RichTextLabel
export (NodePath) onready var PerEasyValue = get_node(PerEasyValue) as RichTextLabel
export (NodePath) onready var PerNormalValue = get_node(PerNormalValue) as RichTextLabel
export (NodePath) onready var PerProblematicValue = get_node(PerProblematicValue) as RichTextLabel
export (NodePath) onready var PerHardValue = get_node(PerHardValue) as RichTextLabel
export (NodePath) onready var PerVeryHardValue = get_node(PerVeryHardValue) as RichTextLabel
export (NodePath) onready var PerFuckingHardValue = get_node(PerFuckingHardValue) as RichTextLabel
export (NodePath) onready var PerLuckValue = get_node(PerLuckValue) as RichTextLabel
onready var PerModifiersList = [PerEasyValue,PerNormalValue,PerProblematicValue,PerHardValue,PerVeryHardValue,PerFuckingHardValue,PerLuckValue]

#CHARACTER
export (NodePath) onready var CharacterAttributeValue = get_node(CharacterAttributeValue) as RichTextLabel
export (NodePath) onready var ChaEasyValue = get_node(ChaEasyValue) as RichTextLabel
export (NodePath) onready var ChaNormalValue = get_node(ChaNormalValue) as RichTextLabel
export (NodePath) onready var ChaProblematicValue = get_node(ChaProblematicValue) as RichTextLabel
export (NodePath) onready var ChaHardValue = get_node(ChaHardValue) as RichTextLabel
export (NodePath) onready var ChaVeryHardValue = get_node(ChaVeryHardValue) as RichTextLabel
export (NodePath) onready var ChaFuckingHardValue = get_node(ChaFuckingHardValue) as RichTextLabel
export (NodePath) onready var ChaLuckValue = get_node(ChaLuckValue) as RichTextLabel
onready var ChaModifiersList = [ChaEasyValue,ChaNormalValue,ChaProblematicValue,ChaHardValue,ChaVeryHardValue,ChaFuckingHardValue,ChaLuckValue]

#WITS
export (NodePath) onready var WitsAttributeValue = get_node(WitsAttributeValue) as RichTextLabel
export (NodePath) onready var WitEasyValue = get_node(WitEasyValue) as RichTextLabel
export (NodePath) onready var WitNormalValue = get_node(WitNormalValue) as RichTextLabel
export (NodePath) onready var WitProblematicValue = get_node(WitProblematicValue) as RichTextLabel
export (NodePath) onready var WitHardValue = get_node(WitHardValue) as RichTextLabel
export (NodePath) onready var WitVeryHardValue = get_node(WitVeryHardValue) as RichTextLabel
export (NodePath) onready var WitFuckingHardValue = get_node(WitFuckingHardValue) as RichTextLabel
export (NodePath) onready var WitLuckValue = get_node(WitLuckValue) as RichTextLabel
onready var WitModifiersList = [WitEasyValue,WitNormalValue,WitProblematicValue,WitHardValue,WitVeryHardValue,WitFuckingHardValue,WitLuckValue]

#BODY
export (NodePath) onready var BodyAttributeValue = get_node(BodyAttributeValue) as RichTextLabel
export (NodePath) onready var BodEasyValue = get_node(BodEasyValue) as RichTextLabel
export (NodePath) onready var BodNormalValue = get_node(BodNormalValue) as RichTextLabel
export (NodePath) onready var BodProblematicValue = get_node(BodProblematicValue) as RichTextLabel
export (NodePath) onready var BodHardValue = get_node(BodHardValue) as RichTextLabel
export (NodePath) onready var BodVeryHardValue = get_node(BodVeryHardValue) as RichTextLabel
export (NodePath) onready var BodFuckingHardValue = get_node(BodFuckingHardValue) as RichTextLabel
export (NodePath) onready var BodLuckValue = get_node(BodLuckValue) as RichTextLabel
onready var BodModifiersList= [BodEasyValue,BodNormalValue,BodProblematicValue,BodHardValue,BodVeryHardValue,BodFuckingHardValue,BodLuckValue]

onready var ATTRIBUTES = GlobalConstants.attribute
func _ready():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP


func _on_CloseButton_button_up():
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP

func updateValues():
	Ethnicity.bbcode_text = characterStats.Ethnicity
	EthnicityTrait.bbcode_text = characterStats.EthnicityTrait


func _on_Ethnicity_ethnicity_chosen(traitButton, ethnicity, attribute):
	var traitName
	if traitButton.traitName == "Wszechstronność do kwadratu":
		traitName = traitButton.traitName +" : " + traitButton.secondary_trait
	else:
		traitName = traitButton.traitName
	self.characterStats.Ethnicity = ethnicity["Name"]
	self.characterStats.EthnicityTrait = traitName
	self.setBonusAttribute(attribute)
	for attr in GlobalConstants.attribute:
		self.updateAttributeValues(GlobalConstants.attribute[attr])
	self.updateValues()

func updateAttributeValues(attributeEnum):
	var value
	match attributeEnum:
		GlobalConstants.attribute.AGI:
			value = getFinalAttributeValue(self.characterStats.agiModifiers)
			self.characterStats.agiValue = value
			AgilityAttributeValue.bbcode_text ="[center]%s[/center]" %  value
			fillAttributeModifiers(value, AgiModifiersList)
		GlobalConstants.attribute.BOD:
			value = getFinalAttributeValue(self.characterStats.bodModifiers)
			self.characterStats.bodValue = value
			BodyAttributeValue.bbcode_text ="[center]%s[/center]" %  value
			fillAttributeModifiers(value, BodModifiersList)
		GlobalConstants.attribute.CHA:
			value = getFinalAttributeValue(self.characterStats.chaModifiers)
			self.characterStats.chaValue = value
			CharacterAttributeValue.bbcode_text ="[center]%s[/center]" %  value
			fillAttributeModifiers(value, ChaModifiersList)
		GlobalConstants.attribute.PER:
			value = getFinalAttributeValue(self.characterStats.perModifiers)
			self.characterStats.perValue = value
			PerceptionAttributeValue.bbcode_text ="[center]%s[/center]" %  value
			fillAttributeModifiers(value, PerModifiersList)
		GlobalConstants.attribute.WIT:
			value = getFinalAttributeValue(self.characterStats.witModifiers)
			self.characterStats.witValue = value
			WitsAttributeValue.bbcode_text ="[center]%s[/center]" %  value
			fillAttributeModifiers(value, WitModifiersList)

func getFinalAttributeValue(attributeModifiers :Dictionary):
	var result = 0
	for key in attributeModifiers:
		result+=attributeModifiers[key]
	return result

func fillAttributeModifiers(attributeValue: int, attributeModifiersElements: Array):
	attributeModifiersElements[0].bbcode_text = returnModifierValueOrN(attributeValue+2)
	attributeModifiersElements[1].bbcode_text = returnModifierValueOrN(attributeValue)
	attributeModifiersElements[2].bbcode_text = returnModifierValueOrN(attributeValue-2)
	attributeModifiersElements[3].bbcode_text = returnModifierValueOrN(attributeValue-5)
	attributeModifiersElements[4].bbcode_text = returnModifierValueOrN(attributeValue-8)
	attributeModifiersElements[5].bbcode_text = returnModifierValueOrN(attributeValue-11)
	attributeModifiersElements[6].bbcode_text = returnModifierValueOrN(attributeValue-15)

func returnModifierValueOrN(value):
	if value < 1:
		return "[center]N[/center]"
	return str("[center]%s[/center]" %value)
func setBonusAttribute(attribute=null):
	#CLEAR PREVIOUS MODIFIER
	self.characterStats.agiModifiers["EthnicityAttributeModifier"] = 0
	self.characterStats.bodModifiers["EthnicityAttributeModifier"] = 0
	self.characterStats.chaModifiers["EthnicityAttributeModifier"] = 0
	self.characterStats.perModifiers["EthnicityAttributeModifier"] = 0
	self.characterStats.witModifiers["EthnicityAttributeModifier"] = 0

	#SET NEW MODIFIER
	if attribute == 0:
		self.characterStats.agiModifiers["EthnicityAttributeModifier"] = 1
	elif attribute == 1:
		self.characterStats.perModifiers["EthnicityAttributeModifier"] = 1
	elif attribute == 2:
		self.characterStats.witModifiers["EthnicityAttributeModifier"] = 1
	elif attribute == 3:
		self.characterStats.bodModifiers["EthnicityAttributeModifier"] = 1
	elif attribute == 4:
		self.characterStats.chaModifiers["EthnicityAttributeModifier"] = 1
	else:
		print("DIDNT MATCH ANYTHING")
		
