extends Node


#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export (NodePath) onready var skill_card1 = get_node(skill_card1) as Control
export (NodePath) onready var skill_card2 = get_node(skill_card2) as Control
export (NodePath) onready var skill_card3 = get_node(skill_card3) as Control
export (NodePath) onready var pack_name_label = get_node(pack_name_label) as Label
export (NodePath) onready var skill_description = get_node(skill_description) as RichTextLabel
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _skill_card_list = []
var _skill_packs_list = []
var _current_skill_pack_data = {}
var _current_skill_pack_index = 0
var _skill_levels = {}

#####################################
# ONREADY VARIABLES
#####################################

#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass

func load_step(skill_level_data):
	_skill_card_list = [skill_card1,skill_card2,skill_card3]
	_skill_packs_list = DatabaseOperations.read_all_skill_packs()
	_skill_levels = skill_level_data
	_skill_levels["brawl"] = 2
	_load_package()


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################
func _load_package():
	var pack_data = DatabaseOperations.read_skills_for_package(_skill_packs_list[_current_skill_pack_index]["skill_pack_identifier"])
	pack_name_label.text = _skill_packs_list[_current_skill_pack_index]["skill_pack_name"]
	for index in range(0, len(pack_data)):
		var current_skill_card = _skill_card_list[index]
		var skill = pack_data[index]
		current_skill_card.skill_name = skill["skill_name"]
		current_skill_card.level = _skill_levels[skill["skill_identifier"]]
		current_skill_card.description = skill["skill_description"]
		current_skill_card.update_skill_card_text()
	skill_description.bbcode_text = _skill_card_list[0].description

func _on_NextPack_button_up():
	_current_skill_pack_index += 1
	if _current_skill_pack_index >= len(_skill_packs_list):
		_current_skill_pack_index = 0
	_load_package()


func _on_PreviousPack_button_up():
	_current_skill_pack_index -= 1
	if _current_skill_pack_index < 0:
		_current_skill_pack_index = len(_skill_packs_list)-1
	_load_package()


func _on_SkillCard_minus_button_pressed(skill):
	if skill.level > 0:
		skill.level -= 1
	skill.update_skill_card_text()


func _on_SkillCard_plus_button_pressed(skill):
	skill.level += 1
	skill.update_skill_card_text()


func _on_SkillCard_skill_element_pressed(skill):
	print(skill.description)
	skill_description.bbcode_text = skill.description
