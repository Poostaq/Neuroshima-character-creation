extends "res://Scripts/SkillPointsPage/SkillPackSkill.gd"

signal general_knowledge_skill_selected(skill_object, index)

onready var option_button = $"%OptionButton"

var general_skill_data

func update_text():
	skill_level.text = str(skill_data.level)

func load_general_knowledge_skills():
	general_skill_data = DatabaseOperations.read_general_knowledge_skills()
	for element in general_skill_data:
		option_button.add_item(tr(element.name))

func refresh_option_states(index_list):
	for index in range(0, option_button.get_item_count()):
		option_button.set_item_disabled(index, false)
	for index in index_list:
		if index != option_button.get_selected_id():
			option_button.set_item_disabled(index, true)

func _on_OptionButton_item_selected(index):
	emit_signal("general_knowledge_skill_selected", self, index)
