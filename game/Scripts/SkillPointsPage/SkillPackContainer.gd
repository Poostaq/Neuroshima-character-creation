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
onready var list_of_skill_objects = [skill_object1,skill_object2,skill_object3]

func update_texts():
	pack_name.text = tr(skill_pack_data.name).to_upper()
	var text_for_spec = tr("pack_specialization_label")
	specialization_of_pack.text = text_for_spec % tr(skill_pack_data.specialization_name)

func update_skill_data():
	for i in range(0,skill_pack_data.skill_data.size()):
		var skill = list_of_skill_objects[i]
		skill.skill_data = skill_pack_data.skill_data[i]
		skill.update_text()
		if skill_pack_data.identifier == "general_knowledge":
			skill.load_general_knowledge_skills()
			skill.skill_data.duplicate(skill.general_skill_data[i])
			skill.option_button.select(i)
	if skill_pack_data.identifier == "general_knowledge":
		for i in range(0,skill_pack_data.skill_data.size()):
			list_of_skill_objects[i].refresh_option_states([0,1,2])
			
func set_plus_minus_button_state():
	for index in range(0,len(skill_pack_data.skill_data)):
		if list_of_skill_objects[index].skill_data.level == GlobalVariables.max_skill_level:
			list_of_skill_objects[index].plus.disabled = true
		else:
			list_of_skill_objects[index].plus.disabled = false
		var minimal_level = CharacterStats.get_pack_data(
			skill_pack_data, 
			CharacterStats.skill_data_before_skill_distribution
			).skill_data[index].level
		if list_of_skill_objects[index].skill_data.level == minimal_level:
			list_of_skill_objects[index].minus.disabled = true
		elif list_of_skill_objects[index].skill_data.level == 1 and self.skill_pack_data.bought:
			list_of_skill_objects[index].minus.disabled = true
		else:
			list_of_skill_objects[index].minus.disabled = false

func set_buy_sell_button_state():
	if _is_all_skill_levels_n(self.list_of_skill_objects, 0):
		self.buy_pack_button.disabled = false
	else:
		self.buy_pack_button.disabled = true
	if _is_all_skill_levels_n(self.list_of_skill_objects, 1):
		self.sell_pack_button.disabled = false
	else:
		self.sell_pack_button.disabled = true

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
