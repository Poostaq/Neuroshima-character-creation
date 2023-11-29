extends Control

#BasicInfo
onready var name_element = $"%NameElement"
onready var ethnicity_element = $"%EthnicityElement"
onready var ethnicity_trait_element = $"%EthnicityTraitElement"
onready var specialization_element = $"%SpecializationElement"
onready var profession_element = $"%ProfessionElement"
onready var profession_trait_element = $"%ProfessionTraitElement"

#Statistics
##Agility
onready var agility_attribute_value = $"%AgilityAttributeValue"
onready var agi_easy_value = $"%AgiEasyValue"
onready var agi_normal_value = $"%AgiNormalValue"
onready var agi_problematic_value = $"%AgiProblematicValue"
onready var agi_hard_value = $"%AgiHardValue"
onready var agi_very_hard_value = $"%AgiVeryHardValue"
onready var agi_fucking_hard_value = $"%AgiFuckingHardValue"
onready var agi_luck_value = $"%AgiLuckValue"
##Perception
onready var perception_attribute_value = $"%PerceptionAttributeValue"
onready var per_easy_value = $"%PerEasyValue"
onready var per_normal_value = $"%PerNormalValue"
onready var per_problematic_value = $"%PerProblematicValue"
onready var per_hard_value = $"%PerHardValue"
onready var per_very_hard_value = $"%PerVeryHardValue"
onready var per_fucking_hard_value = $"%PerFuckingHardValue"
onready var per_luck_value = $"%PerLuckValue"
##Character
onready var character_attribute_value = $"%CharacterAttributeValue"
onready var cha_easy_value = $"%ChaEasyValue"
onready var cha_normal_value = $"%ChaNormalValue"
onready var cha_problematic_value = $"%ChaProblematicValue"
onready var cha_hard_value = $"%ChaHardValue"
onready var cha_very_hard_value = $"%ChaVeryHardValue"
onready var cha_fucking_hard_value = $"%ChaFuckingHardValue"
onready var cha_luck_value = $"%ChaLuckValue"
##Wits
onready var wits_attribute_value = $"%WitsAttributeValue"
onready var wit_easy_value = $"%WitEasyValue"
onready var wit_normal_value = $"%WitNormalValue"
onready var wit_problematic_value = $"%WitProblematicValue"
onready var wit_hard_value = $"%WitHardValue"
onready var wit_very_hard_value = $"%WitVeryHardValue"
onready var wit_fucking_hard_value = $"%WitFuckingHardValue"
onready var wit_luck_value = $"%WitLuckValue"
##Body
onready var body_attribute_value = $"%BodyAttributeValue"
onready var bod_easy_value = $"%BodEasyValue"
onready var bod_normal_value = $"%BodNormalValue"
onready var bod_problematic_value = $"%BodProblematicValue"
onready var bod_hard_value = $"%BodHardValue"
onready var bod_very_hard_value = $"%BodVeryHardValue"
onready var bod_fucking_hard_value = $"%BodFuckingHardValue"
onready var bod_luck_value = $"%BodLuckValue"
##Helpers
onready var agi_modifiers_elements = [agi_easy_value,agi_normal_value,agi_problematic_value,agi_hard_value,agi_very_hard_value,agi_fucking_hard_value,agi_luck_value]
onready var per_modifiers_elements = [per_easy_value,per_normal_value,per_problematic_value,per_hard_value,per_very_hard_value,per_fucking_hard_value,per_luck_value]
onready var cha_modifiers_elements = [cha_easy_value,cha_normal_value,cha_problematic_value,cha_hard_value,cha_very_hard_value,cha_fucking_hard_value,cha_luck_value]
onready var wit_modifiers_elements = [wit_easy_value,wit_normal_value,wit_problematic_value,wit_hard_value,wit_very_hard_value,wit_fucking_hard_value,wit_luck_value]
onready var bod_modifiers_elements = [bod_easy_value,bod_normal_value,bod_problematic_value,bod_hard_value,bod_very_hard_value,bod_fucking_hard_value,bod_luck_value]
onready var attribute_modifiers_elements = [agi_modifiers_elements,per_modifiers_elements,cha_modifiers_elements,wit_modifiers_elements,bod_modifiers_elements]
onready var attribute_value_elements = [agility_attribute_value,perception_attribute_value,character_attribute_value,wits_attribute_value,body_attribute_value]
#Skills
##MeleeFight
onready var brawl = $"%Brawl"
onready var melee_weapon = $"%MeleeWeapon"
onready var throwing = $"%Throwing"
##Driving
onready var car = $"%Car"
onready var motorcycle = $"%Motorcycle"
onready var truck = $"%Truck"
##ManualSkills
onready var pickpocketing = $"%Pickpocketing"
onready var lockpicking = $"%Lockpicking"
onready var nimble_hands = $"%NimbleHands"
##Arms
onready var pistols = $"%Pistols"
onready var rifles = $"%Rifles"
onready var machineguns = $"%Machineguns"
##RangedWeapons
onready var bow = $"%Bow"
onready var crossbow = $"%Crossbow"
onready var slingshot = $"%Slingshot"
##OtherSkills
onready var other_skill_1 = $"%OtherSkill1"
onready var other_skill_2 = $"%OtherSkill2"
onready var other_skill_3 = $"%OtherSkill3"
##FieldOrientation
onready var sense_of_direction = $"%SenseOfDirection"
onready var traps = $"%Traps"
onready var tracking = $"%Tracking"
##Perceptivity
onready var listening = $"%Listening"
onready var spotting = $"%Spotting"
onready var vigilance = $"%Vigilance"
##Camouflage
onready var sneaking = $"%Sneaking"
onready var hiding = $"%Hiding"
onready var cloaking = $"%Cloaking"
##Survival
onready var hunting = $"%Hunting"
onready var terrain_knowledge = $"%TerrainKnowledge"
onready var water_aquisition = $"%WaterAquisition"
##Negotiation
onready var intimidation = $"%Intimidation"
onready var persuasion = $"%Persuasion"
onready var leadership = $"%Leadership"
##Empathy
onready var perceiving_emotions = $"%PerceivingEmotions"
onready var bluff = $"%Bluff"
onready var animal_care = $"%AnimalCare"
##Willpower
onready var pain_resistance = $"%PainResistance"
onready var steadfastness = $"%Steadfastness"
onready var morale = $"%Morale"
##Medicine
onready var first_aid = $"%FirstAid"
onready var wound_healing = $"%WoundHealing"
onready var disease_treatment = $"%DiseaseTreatment"
##Technology
onready var mechanics = $"%Mechanics"
onready var electronics = $"%Electronics"
onready var computers = $"%Computers"
##GeneralKnowledge
onready var knowledge_name_1 = $"%KnowledgeName1"
onready var knowledge_value_1 = $"%KnowledgeValue1"
onready var knowledge_name_2 = $"%KnowledgeName2"
onready var knowledge_value_2 = $"%KnowledgeValue2"
onready var knowledge_name_3 = $"%KnowledgeName3"
onready var knowledge_value_3 = $"%KnowledgeValue3"

onready var general_knowledge_name_labels = [knowledge_name_1,knowledge_name_2,knowledge_name_3]
##Equipment
onready var heavy_machinery = $"%HeavyMachinery"
onready var combat_vehicles = $"%CombatVehicles"
onready var boats = $"%Boats"
##Pyrotechnics
onready var gunsmithing = $"%Gunsmithing"
onready var launchers = $"%Launchers"
onready var explosives = $"%Explosives"
##Performance
onready var fitness = $"%Fitness"
onready var swimming = $"%Swimming"
onready var climbing = $"%Climbing"
##Horsemanship
onready var horse_riding = $"%HorseRiding"
onready var carriage_driving = $"%CarriageDriving"
onready var wild_ride = $"%WildRide"
#Armor
onready var armor_head = $"%ArmorHead"
onready var armor_body = $"%ArmorBody"
onready var armor_left_hand = $"%ArmorLeftHand"
onready var armor_right_hand = $"%ArmorRightHand"
onready var armor_left_leg = $"%ArmorLeftLeg"
onready var armor_right_leg = $"%ArmorRightLeg"

onready var skills_labels = {
	"brawl":brawl,
	"melee_weapon":melee_weapon,
	"throwing":throwing,
	"car":car,
	"motorcycle":motorcycle,
	"truck":truck,
	"pickpocketing":pickpocketing,
	"lockpicking":lockpicking,
	"nimble_hands":nimble_hands,
	"pistols":pistols,
	"rifles":rifles,
	"machine_gun":machineguns,
	"bow":bow,
	"crossbow":crossbow,
	"slingshot":slingshot,
	"sense_of_direction":sense_of_direction,
	"traps":traps,
	"tracking":tracking,
	"listening":listening,
	"watching_out":spotting,
	"vigilance":vigilance,
	"sneaking":sneaking,
	"hiding":hiding,
	"cloaking":cloaking,
	"hunting":hunting,
	"terrain_knowledge":terrain_knowledge,
	"water_aquisition":water_aquisition,
	"intimidation":intimidation,
	"persuasion":persuasion,
	"leadership_abilities":leadership,
	"perceiving_emotions":perceiving_emotions,
	"bluff":bluff,
	"animal_care":animal_care,
	"pain_resistance":pain_resistance,
	"steadfastness":steadfastness,
	"morale":morale,
	"first_aid":first_aid,
	"wound_healing":wound_healing,
	"disease_treatment":disease_treatment,
	"mechanics":mechanics,
	"electronics":electronics,
	"computers":computers,
	"general_knowledge1":knowledge_value_1,
	"general_knowledge2":knowledge_value_2,
	"general_knowledge3":knowledge_value_3,
	"heavy_machinery":heavy_machinery,
	"combat_vehicles":combat_vehicles,
	"boats":boats,
	"gunsmithing":gunsmithing,
	"launchers":launchers,
	"explosives":explosives,
	"fitness":fitness,
	"swimming":swimming,
	"climbing":climbing,
	"horse_riding":horse_riding,
	"carriage_driving":carriage_driving,
	"wild_ride":wild_ride,
}
#Weapons
##Weapon1
onready var w_1_name = $"%W1Name"
onready var w_1_damage = $"%W1Damage"
onready var w_1_special_rules = $"%W1SpecialRules"
onready var w_1_fire_modes = $"%W1FireModes"
onready var w_1_fire_rate = $"%W1FireRate"
onready var w_1_ammo_type = $"%W1AmmoType"
onready var w_1_jamming_range = $"%W1JammingRange"
onready var w_1_current_magazine = $"%W1CurrentMagazine"
onready var w_1_ammo = $"%W1Ammo"
##Weapon2
onready var w_2_name = $"%W2Name"
onready var w_2_damage = $"%W2Damage"
onready var w_2_special_rules = $"%W2SpecialRules"
onready var w_2_fire_modes = $"%W2FireModes"
onready var w_2_fire_rate = $"%W2FireRate"
onready var w_2_ammo_type = $"%W2AmmoType"
onready var w_2_jamming_range = $"%W2JammingRange"
onready var w_2_current_magazine = $"%W2CurrentMagazine"
onready var w_2_ammo = $"%W2Ammo"
##Weapon3
onready var w_3_name = $"%W3Name"
onready var w_3_damage = $"%W3Damage"
onready var w_3_special_rules = $"%W3SpecialRules"
onready var w_3_fire_modes = $"%W3FireModes"
onready var w_3_fire_rate = $"%W3FireRate"
onready var w_3_ammo_type = $"%W3AmmoType"
onready var w_3_jamming_range = $"%W3JammingRange"
onready var w_3_current_magazine = $"%W3CurrentMagazine"
onready var w_3_ammo = $"%W3Ammo"
##MeleeWeapon1
onready var mw_1_name = $"%MW1Name"
onready var mw_1_agi_attack_bonus = $"%MW1AgiAttackBonus"
onready var mw_1_agi_def_bonus = $"%MW1AgiDefBonus"
onready var mw_1_damage_1s = $"%MW1Damage1s"
onready var mw_1_damage_2s = $"%MW1Damage2s"
onready var mw_1_damage_3s = $"%MW1Damage3s"
onready var mw_1_special_rules = $"%MW1SpecialRules"
##MeleeWeapon2
onready var mw_2_name = $"%MW2Name"
onready var mw_2_agi_attack_bonus = $"%MW2AgiAttackBonus"
onready var mw_2_agi_def_bonus = $"%MW2AgiDefBonus"
onready var mw_2_damage_1s = $"%MW2Damage1s"
onready var mw_2_damage_2s = $"%MW2Damage2s"
onready var mw_2_damage_3s = $"%MW2Damage3s"
onready var mw_2_special_rules = $"%MW2SpecialRules"
#Aquaintances
onready var aquaintance_1 = $"%Aquaintance1"
onready var aquaintance_2 = $"%Aquaintance2"
onready var aquaintance_3 = $"%Aquaintance3"
onready var aquaintance_4 = $"%Aquaintance4"
onready var aquaintance_5 = $"%Aquaintance5"
onready var aquaintance_list = [aquaintance_1,aquaintance_2,aquaintance_3,aquaintance_4,aquaintance_5]
#Tricks
onready var trick_1 = $"%Trick1"
onready var trick_2 = $"%Trick2"
onready var trick_3 = $"%Trick3"
onready var trick_4 = $"%Trick4"
onready var trick_5 = $"%Trick5"

onready var db = get_node("/root/DatabaseOperations")


func update_card() -> void:
	for attr in GlobalVariables.attribute:
		self._update_attribute_values(GlobalVariables.attribute[attr])
	self._update_basic_info_values()
	self._update_skill_levels()


func _update_attribute_values(attributeEnum) -> void:
	if attributeEnum == GlobalVariables.attribute.ANY:
		return
	var value = CharacterStats.get_final_attribute_value(CharacterStats.attribute_modifiers_dicts[attributeEnum])
	CharacterStats.attribute_values_list[attributeEnum] = value
	attribute_value_elements[attributeEnum].text ="%s" %  value
	_fill_attribute_modifiers(value, attribute_modifiers_elements[attributeEnum])


func _update_basic_info_values() -> void:
	ethnicity_element.text = CharacterStats.ethnicity
	ethnicity_trait_element.text = CharacterStats.ethnicity_trait
	profession_element.text = CharacterStats.profession
	profession_trait_element.text = CharacterStats.profession_trait
	specialization_element.text = CharacterStats.specialization


func _update_skill_levels() -> void:
	for skill in CharacterStats.skill_levels:
		if skills_labels.has(skill):
			skills_labels[skill].text = str(CharacterStats.skill_levels[skill])
	for index in range(0,3):
		general_knowledge_name_labels[index].text = CharacterStats.general_knowledge_names[index]


func _fill_attribute_modifiers(attribute_value: int, attr_mod_elements: Array) -> void:
	var modifiers = DatabaseOperations.read_list_of_modifiers()
	for m in range(0, modifiers.size()):
		attr_mod_elements[m].text = _return_modifier_value_or_n(attribute_value + modifiers[m])


func _return_modifier_value_or_n(value: int) -> String:
	if value < 1:
		return "N"
	return str("%s" %value)


func _on_CloseButton_button_up() -> void:
	self.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP