extends Control

export var tricks_data_list: Array

onready var trick_object = preload("res://Scenes/TricksPage/TrickObject.tscn")
onready var rule_description_scene = preload("res://Scenes/TricksPage/RuleDescriptionObject.tscn")
onready var tricks_list = $"%TricksList"
onready var trick_name = $"%TrickName"
onready var description_text = $"%DescriptionText"
onready var requirements_label = $"%RequirementsLabel"
onready var behaviour_action_list = $"%BehaviourActionList"
onready var behaviour_action_container = $"%BehaviourActionContainer"

func _init():
	tricks_data_list = DatabaseOperations.get_tricks_data_for_character_stats()

func _ready():
	load_step()
	
func load_step():
	for child in tricks_list.get_children():
		child.queue_free()
	for trick_data in tricks_data_list:
		create_new_trick_object(trick_data)
	clear_action_space()
	tricks_list.get_children()[1]._on_TrickObject_button_up()

func create_new_trick_object(trick_data: Dictionary):
	var trick_object_instance = trick_object.instance()
	tricks_list.add_child(trick_object_instance)
	trick_object_instance.trick_data = trick_data
	trick_object_instance.set_trick_name()
	trick_object_instance.connect("trick_button_pressed", self, "_on_trick_button_pressed")

func _on_trick_button_pressed(trick_identifier):
	behaviour_action_container.visible = true
	var trick_data = DatabaseOperations.get_trick_by_name(trick_identifier)
	trick_name.text = tr(trick_data["trick_name"])
	description_text.bbcode_text = tr(trick_data["trick_description"])
	requirements_label.text = tr(trick_data["trick_requirements"])
	clear_action_space()
	create_new_rule_description_object(trick_data["trick_action"])

func create_new_rule_description_object(data):
	var rule_description_object = rule_description_scene.instance()
	behaviour_action_list.add_child(rule_description_object)
	rule_description_object.bbcode_text = data

func clear_action_space():
	for child in behaviour_action_list.get_children():
		child.queue_free()
