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
export (NodePath) onready var skill_card1 = get_node(skill_card1) as TextureRect
export (NodePath) onready var skill_card2 = get_node(skill_card2) as TextureRect
export (NodePath) onready var skill_card3 = get_node(skill_card3) as TextureRect
export (NodePath) onready var pack_name_label = get_node(pack_name_label) as Label
#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _skill_card_list = []
var _skill_packs_list = []
var _current_skill_pack_data = {}
var _current_skill_pack_index = 14
#####################################
# ONREADY VARIABLES
#####################################
onready var db = get_node("/root/DatabaseOperations")

#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass

func load_step():
	_skill_card_list = [skill_card1,skill_card2,skill_card3]
	_skill_packs_list = db.read_all_skill_packs()
	_load_package()


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################
func _load_package():
	var pack_data = db.read_skills_for_package(_skill_packs_list[_current_skill_pack_index]["skill_pack_identifier"])
	pack_name_label.text = _skill_packs_list[_current_skill_pack_index]["skill_pack_name"]
	for index in range(0, len(pack_data)):
		var current_skill_card = _skill_card_list[index]
		current_skill_card.find_node("SkillName").bbcode_text = "[center] %s" % pack_data[index]["skill_name"]
		current_skill_card.find_node("SkillDescription").bbcode_text = "[center] %s" % pack_data[index]["skill_description"]


func _on_NextPack_button_up():
	_current_skill_pack_index += 1
	if _current_skill_pack_index >= len(_skill_packs_list):
		_current_skill_pack_index = 0
	print(_current_skill_pack_index)
	_load_package()


func _on_PreviousPack_button_up():
	print(_current_skill_pack_index)
	_current_skill_pack_index -= 1
	if _current_skill_pack_index < 0:
		_current_skill_pack_index = len(_skill_packs_list)-1
	_load_package()
