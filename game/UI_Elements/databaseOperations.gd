extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db

var db_name := "res://datastore/neuroshima"
var packaged_db_name := "res://data_to_be_packaged"
var json_name := "res://datastore/neuroshima_backup"

func read_from_SQL():
	db = SQLite.new()
	db.path = db_name
	db.open_db()


func _sql_select(query):
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	db.query(query)
	for i in range(0, db.query_result.size()):
		var _data = db.query_result[i]
	return db.query_result


func read_traits_for_ethnicity(ethnicity_identifier):
	var data = _sql_select("SELECT t.trait_identifier, t.trait_name, t.trait_description " +
	"FROM ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id " +
	"WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	db.close_db()
	return data
	

func read_ethnicity_identifiers():
	var data = _sql_select("SELECT ethnicity_identifier FROM ethnicities;")
	db.close_db()
	return data


func read_data_for_etnicity(ethnicity_identifier):
	var data = _sql_select("SELECT e.ethnicity_identifier, " +
	"e.ethnicity_name, e.splash_art_path, e.ethnicity_description, " +
	"a.attribute_identifier, a.attribute_name, a.attribute_enum, a.bonus_value " +
	"from ethnicities e JOIN attributes a on a.attribute_id = e.attribute_id " +
	"WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	db.close_db()
	return data[0]
	
	
func read_list_of_attributes_without_any():
	read_from_SQL()
	db.open_db()
	var table_name = "attributes"
	var attributes = []
	var select_condition : String = "attribute_identifier != 'Any';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["attribute_name"])
	for selected_row in selected_array:
		attributes.append(selected_row.get("attribute_name"))
	return attributes


func read_list_of_traits_without_versatilities():
	read_from_SQL()
	db.open_db()
	var table_name = "traits"
	var traits = []
	var select_condition : String = "trait_identifier not in ('versatility_squared', 'versatility');"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["trait_name"])
	for selected_row in selected_array:
		traits.append(selected_row.get("trait_name"))
	return traits
