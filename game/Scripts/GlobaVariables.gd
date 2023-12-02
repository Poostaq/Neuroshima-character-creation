extends Node

enum attribute {AGI,PER,CHA,WIT,BOD,ANY}

var max_skill_points = 35
var max_specialization_skill_points = 30
var language = "en"

func _ready():
	max_skill_points = int(DatabaseOperations.get_config_value("max_skill_points")["config_attribute_value"])
	max_specialization_skill_points = int(DatabaseOperations.get_config_value("max_specialization_skill_points")["config_attribute_value"])
	language = DatabaseOperations.get_config_value("language")["config_attribute_value"]


func save_config():
	DatabaseOperations.save_config_value("language", language)
	DatabaseOperations.save_config_value("max_specialization_skill_points", str(max_specialization_skill_points))
	DatabaseOperations.save_config_value("max_skill_points", str(max_skill_points))
