class_name Trick

var trick_id: int
var trick_name: String
var trick_description: String
var trick_behaviour: String
var trick_requirements: String


func _init( new_trick_id: int,
			new_trick_name: String, 
			new_trick_description: String, 
			new_trick_behaviour: String,
			new_trick_requirements: String):
	trick_id = new_trick_id
	trick_name = new_trick_name
	trick_description = new_trick_description
	trick_behaviour = new_trick_behaviour
	trick_requirements = new_trick_requirements
