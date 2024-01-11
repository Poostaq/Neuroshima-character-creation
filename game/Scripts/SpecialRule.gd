class_name SpecialRule


var trait_id: int
var special_rule_name: String
var query: String
var value: int

func _init(new_id, new_name, new_query, new_value):
	trait_id = new_id
	special_rule_name = new_name
	query = new_query
	value = int(new_value)


func perform_special_rule_actions(button):
	match special_rule_name:
		"all_skills":
			CharacterStats.flags["all_skills"] = true
		"always_bad_rep":
			CharacterStats.speciaflagsl_rules["always_bad_rep"] = true
		"bad_fame":
			pass
		"friends":
			pass
		"general_knowledge_alternative":
			CharacterStats.flags["general_knowledge_alternative"] = true
		"general_knowledge_pack":
			var new_skill_pack = DatabaseOperations.create_general_knowledge_alternative_skill_pack()
			for skill in new_skill_pack.skill_data:
				skill.level = 2
			CharacterStats.skill_data[new_skill_pack.identifier] = new_skill_pack
		"low_rep_cost":
			pass
		"more_rep":
			pass
		"one_of_pack_list":
			var skill_packs = DatabaseOperations.sql_command(query)
			var skill_pack_db_data = skill_packs[button.option_button.selected]
			var chosen_skill_pack = CharacterStats.find_pack_data(skill_pack_db_data["skill_pack_identifier"])
			for skill in chosen_skill_pack.skill_data:
				skill.level = value
		"skill_points":
			pass
		"specific_pack":
			var skill_pack_identifier = DatabaseOperations.sql_command(query)[0]["skill_pack_identifier"]
			var specific_pack_pack = CharacterStats.find_pack_data(skill_pack_identifier)
			for skill in specific_pack_pack.skill_data:
				skill.level = value
		"specific_packs":
			var result = DatabaseOperations.sql_command(query)
			for row in result:
				var specific_pack_pack = CharacterStats.find_pack_data(row["skill_pack_identifier"])
				for skill in specific_pack_pack.skill_data:
					skill.level = value
		"trick":
			pass
		_:
			pass
