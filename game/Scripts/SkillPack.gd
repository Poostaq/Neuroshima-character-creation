class_name SkillPack

var skill_data = []

var bought: bool

var attribute_name: String
var identifier: String
var name: String
var specialization_name: String


func _init(new_attribute_name, new_identifier, new_name, new_specialization_name):
	attribute_name = new_attribute_name
	identifier = new_identifier
	name = new_name
	specialization_name = new_specialization_name

func duplicate(class_object: SkillPack):
	var new_skill_list = []
	for i in range(0,class_object.skill_data.size()):
		new_skill_list.append(skill_data[i].duplicate(class_object.skill_data[i]))
	skill_data = new_skill_list
	bought = class_object.bought
	attribute_name = class_object.attribute_name
	identifier = class_object.identifier
	name = class_object.name
	specialization_name = class_object.specialization_name
	