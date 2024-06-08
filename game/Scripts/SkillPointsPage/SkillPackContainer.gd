extends TextureRect

signal mouse_entered_skill_name_of_skill_pack(skill_object)
signal skill_pack_skill_plus_pressed(skill_pack, skill)
signal skill_pack_skill_minus_pressed(skill_pack, skill)
signal buy_pack_button_pressed(skill_pack)
signal sell_pack_button_pressed(skill_pack)
signal general_skill_pack_skill_selected(skill_pack, skill, index)


var skill_pack_data: SkillPack

onready var pack_name = $"%PackName"
onready var specialization_of_pack = $"%SpecializationOfPack"
onready var skill_object1 = $"%SkillObject1"
onready var skill_object2 = $"%SkillObject2"
onready var skill_object3 = $"%SkillObject3"
onready var buy_pack_button = $"%BuyPackButton"
onready var sell_pack_button = $"%SellPackButton"
onready var skill_object_group = $"%SkillObjectGroup"

func update_texts():
	pack_name.text = tr(skill_pack_data.name).to_upper()
	var text_for_spec = tr("pack_specialization_label")
	specialization_of_pack.text = text_for_spec % tr(skill_pack_data.specialization_name)

func update_skill_data():
	var skills = skill_object_group.get_children()
	for i in range(0,skills.size()):
		var skill = skills[i]
		skill.skill_data = skill_pack_data.skill_data[i]
		skill.update_text()
		if skill_pack_data.identifier == "general_knowledge" and not CharacterStats.is_alternative_general_knowledge_active():
			skill.load_general_knowledge_skills()
			
			skill.option_button.select(i)
	if skill_pack_data.identifier == "general_knowledge" and not CharacterStats.is_alternative_general_knowledge_active():
		for i in range(0,skill_pack_data.skill_data.size()):
			skills[i].refresh_option_states([0,1,2])


func _is_all_skill_levels_n(skill_list, n) -> bool:
	for skill in skill_list:
		if skill.skill_data.level != n:
			return false
	return true

func _on_skill_plus_button_pressed(skill_object):
	emit_signal("skill_pack_skill_plus_pressed", self, skill_object)

func _on_skill_minus_button_pressed(skill_object):
	emit_signal("skill_pack_skill_minus_pressed", self, skill_object)

func _on_mouse_entered_skill_object(skill_data: SkillData):
	emit_signal("mouse_entered_skill_name_of_skill_pack", skill_data)

func _on_buy_pack_button_pressed():
	emit_signal("buy_pack_button_pressed", self)

func _on_sell_pack_button_pressed():
	emit_signal("sell_pack_button_pressed", self)

func _on_general_knowledge_skill_selected(skill_object, index):
	emit_signal("general_skill_pack_skill_selected", self, skill_object, index)
