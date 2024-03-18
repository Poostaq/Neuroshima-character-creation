class_name SkillData

var name: String
var level: int
var skill_identifier: String
var description: String
var special_rules: String


func _init(new_name, new_level, new_skill_identifier, new_description):
	name = new_name
	level = new_level
	skill_identifier = new_skill_identifier
	if not description:
		description = ""
	else:
		description = new_description

func duplicate(skill: SkillData):
	for property in skill.get_property_list():
		self.set(property.name, skill.get(property.name))
	return self
