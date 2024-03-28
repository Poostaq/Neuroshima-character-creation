extends Control


var step_name = "form_step_description"
onready var question_1 = $"%Question1"
onready var question_2 = $"%Question2"
onready var question_3 = $"%Question3"
onready var question_4 = $"%Question4"
onready var question_5 = $"%Question5"
onready var question_6 = $"%Question6"
onready var question_list = [question_1,question_2,question_3,question_4,question_5,question_6]
# var a = 2
# var b = "text"
var current_question = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	question_1.get_node("TextureRect/Answer").text = tr("first_answer_default")
	question_2.get_node("TextureRect/Answer").text = tr("second_answer_default")
	question_3.get_node("TextureRect/Answer").text = tr("third_answer_default")
	question_4.get_node("TextureRect/Answer").text = tr("fourth_answer_default")
	question_5.get_node("TextureRect/Answer").text = tr("fifth_answer_default")
	question_6.get_node("TextureRect/Answer").text = tr("sixth_answer_default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
