class_name SkillData

var name: String
var level: int
var skill_identifier: String
var description: String
var special_rules: String



func duplicate(skill: SkillData):
	for property in skill.get_property_list():
		self.set(property.name, skill.get(property.name))
