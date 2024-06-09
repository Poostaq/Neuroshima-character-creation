extends Control

signal enable_next_step_anyway

var step_name = "form_step_description"
onready var question_1 = $"%Question1"
onready var question_2 = $"%Question2"
onready var question_3 = $"%Question3"
onready var question_4 = $"%Question4"
onready var question_5 = $"%Question5"
onready var question_6 = $"%Question6"
onready var question_list = [question_1,question_2,question_3,question_4,question_5,question_6]


var current_question = 0


func _ready():
	question_1.get_node("TextureRect/Answer").text = tr("first_answer_default")
	question_2.get_node("TextureRect/Answer").text = tr("second_answer_default")
	question_3.get_node("TextureRect/Answer").text = tr("third_answer_default")
	question_4.get_node("TextureRect/Answer").text = tr("fourth_answer_default")
	question_5.get_node("TextureRect/Answer").text = tr("fifth_answer_default")
	question_6.get_node("TextureRect/Answer").text = tr("sixth_answer_default")
	var dict = CharacterStats.player_form_answers
	dict["question1"] = ""
	dict["question2"] = ""
	dict["question3"] = ""
	dict["question4"] = ""
	dict["question5"] = ""
	dict["question6"] = ""


func load_step():
	emit_signal("enable_next_step_anyway")


func clean_up_step():
	pass

func _on_SelectedPreviousQuestion_pressed():
	if current_question == 0:
		current_question = 5
	else:
		current_question -= 1
	for index in range(0,len(question_list)):
		if index == current_question:
			question_list[index].visible = true
		else:
			question_list[index].visible = false


func _on_SelectedNextQuestion_pressed():
	if current_question == 5:
		current_question = 0
	else:
		current_question += 1
	for index in range(0,len(question_list)):
		if index == current_question:
			question_list[index].visible = true
		else:
			question_list[index].visible = false

func on_form_finished():
	fill_question_answer("question1", question_1, "first_answer_default")
	fill_question_answer("question2", question_2, "second_answer_default")
	fill_question_answer("question3", question_3, "third_answer_default")
	fill_question_answer("question4", question_4, "fourth_answer_default")
	fill_question_answer("question5", question_5, "fifth_answer_default")
	fill_question_answer("question6", question_6, "sixth_answer_default")
	
func fill_question_answer(question_key, question_object, default_answer):
	var dict = CharacterStats.player_form_answers
	if question_object.get_node("TextureRect/Answer").text == tr(default_answer):
		dict[question_key] = ""
	else:
		dict[question_key] = question_object.get_node("TextureRect/Answer").text
		


func _on_ClearAnswer_pressed():
	question_list[current_question].get_node("TextureRect/Answer").text = ""
