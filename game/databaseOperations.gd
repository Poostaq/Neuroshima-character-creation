extends Node

func read_database_file():
	var data_read = File.new()
	data_read.open("res://database.cdb", File.READ)
	var data_cdb = parse_json(data_read.get_as_text())
	return data_cdb
	
