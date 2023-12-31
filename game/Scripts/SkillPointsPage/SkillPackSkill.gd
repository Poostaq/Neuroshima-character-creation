extends Control

signal on_plus_button_pressed(skill_object)
signal on_minus_button_pressed(skill_object)
signal mouse_entered_skill_object(object)

onready var skill_name = $"%SkillName" as Label
onready var skill_level = $"%SkillLevel" as Label
onready var plus = $"%Plus"
onready var minus = $"%Minus"

onready var skill_data: SkillData



func update_text():
	skill_name.text = skill_data.name
	skill_level.text = str(skill_data.level)

func _on_Plus_pressed():
	emit_signal("on_plus_button_pressed", self)

func _on_Minus_pressed():
	emit_signal("on_minus_button_pressed", self)

func _on_SkillObject_mouse_entered():
	emit_signal("mouse_entered_skill_object", self.skill_data)
