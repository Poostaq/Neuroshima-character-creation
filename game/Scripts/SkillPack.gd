class_name SkillPack

var skill1_data: SkillData
var skill2_data: SkillData
var skill3_data: SkillData


var skill_data = [skill1_data, skill2_data, skill3_data]

var bought: bool

var attribute_name: String
var identifier: String
var name: String
var specialization_name: String


func duplicate(class_object: SkillPack):
	for index in range(0, len(skill_data)):
		skill_data[index].duplicate(class_object.skill_data[index])
	bought = class_object.bought
	attribute_name = class_object.attribute_name
	identifier = class_object.identifier
	name = class_object.name
	specialization_name = class_object.specialization_name
	
