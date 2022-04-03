extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db


var db_name := "res://datastore/neuroshima"
var packaged_db_name := "res://data_to_be_packaged"
var json_name := "res://datastore/neuroshima_backup"

var table_name := "Attributes"
var ethnicity_table_name := "Ethnicity"
var traits_table_name = "Traits"
var traits_table_name = "Traits"

var identifiers := ["Agility", "Perception", "Character", "Wits", "Body", "Any"]

func read_database_file():
	var data_read = File.new()
	data_read.open("res://database.cdb", File.READ)
	var data_cdb = parse_json(data_read.get_as_text())
	return data_cdb
	
func read_table_from_database(tableName: String):
	var db = self.read_database_file()
	var sheets = db["sheets"]
	var table = []
	for sheet in sheets:
		if sheet["name"] == tableName:
			table = sheet["lines"]
	if table != []:
		return table
	else:
		print("REQUESTED TABLE %s IS EMPTY" % tableName)
