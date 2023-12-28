extends TextureRect

signal mouse_entered_skill_name_of_skill_pack(skill_object)
signal skill_pack_skill_plus_pressed(skill_pack, skill)

var skill_pack_data: SkillPack

onready var pack_name = $"%PackName"
onready var specialization_of_pack = $"%SpecializationOfPack"
onready var skill_object1 = $"%SkillObject1"
onready var skill_object2 = $"%SkillObject2"
onready var skill_object3 = $"%SkillObject3"
onready var list_of_skill_objects = [skill_object1,skill_object2,skill_object3]

func update_texts():
	pack_name.text = tr(skill_pack_data.name).to_upper()
	var text_for_spec = tr("pack_specialization_label")
	specialization_of_pack.text = text_for_spec % tr(skill_pack_data.specialization_name)

func update_skill_data():
	for i in range(0,skill_pack_data.skill_data.size()):
		var skill = list_of_skill_objects[i]
		skill.skill_data = skill_pack_data.skill_data[i]
		skill.skill_setup()


func _on_skill_plus_button_pressed(skill_object):
	emit_signal("skill_pack_skill_plus_pressed", self, skill_object)


func _on_mouse_entered_skill_object(skill_data: SkillData):
	emit_signal("mouse_entered_skill_name_of_skill_pack", skill_data)
