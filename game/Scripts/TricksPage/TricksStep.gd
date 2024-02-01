extends Control

export var tricks_data_list: Array

onready var trick_object = preload("res://Scenes/TricksPage/TrickObject.tscn")
onready var action_object_scene = preload("res://Scenes/TricksPage/ActionObject.tscn")
onready var tricks_list = $"%TricksList"
onready var trick_name = $"%TrickName"
onready var description_text = $"%DescriptionText"
onready var behaviour_text = $"%BehaviourText"
onready var requirements_label = $"%RequirementsLabel"
onready var action_list = $"%ActionList"

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
	tricks_list.get_children()[0]._on_TrickObject_button_up()

func create_new_trick_object(trick_data: Dictionary):
	var trick_object_instance = trick_object.instance()
	tricks_list.add_child(trick_object_instance)
	trick_object_instance.trick_data = trick_data
	trick_object_instance.set_trick_name()
	trick_object_instance.connect("trick_button_pressed", self, "_on_trick_button_pressed")

func _on_trick_button_pressed(trick_identifier):
	var trick_data: Trick = DatabaseOperations.get_trick_by_name(trick_identifier)
	trick_name.text = tr(trick_data.trick_name)
	description_text.bbcode_text = tr(trick_data.trick_description)
	behaviour_text.bbcode_text = tr(trick_data.trick_behaviour)
	requirements_label.text = tr(trick_data.trick_requirements)
	clear_action_space()
	var action_data = DatabaseOperations.get_trick_actions(trick_data.trick_id)
	if action_data:
		for action in action_data:
			create_new_action_object(action)
	else:
		clear_action_space()
		

func create_new_action_object(data):
	var action_object = action_object_scene.instance()
	action_list.add_child(action_object)
	action_object.action_name.text = data["trick_action_name"]
	action_object.action_description.bbcode_text = tr(data["trick_action_description"])

func clear_action_space():
	for child in action_list.get_children():
		child.queue_free()


func _on_SelectedTrick_pressed():
	pass # Replace with function body.
