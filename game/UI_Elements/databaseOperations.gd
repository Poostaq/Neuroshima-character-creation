extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db_sql

var db_name := "res://datastore/neuroshima"
var packaged_db_name := "res://data_to_be_packaged"
var json_name := "res://datastore/neuroshima_backup"

func read_from_SQL():
	db_sql = SQLite.new()
	db_sql.path = db_name
	db_sql.open_db()

#func read_database_file():
#	var data_read = File.new()
#	data_read.open("res://database.cdb", File.READ)
#	var data_cdb = parse_json(data_read.get_as_text())
#	return data_cdb
#
#func read_table_from_database(tableName: String):
#	var db = self.read_database_file()
#	var sheets = db["sheets"]
#	var table = []
#	for sheet in sheets:
#		if sheet["name"] == tableName:
#			table = sheet["lines"]
#	if table != []:
#		return table
#	else:
#		print("REQUESTED TABLE %s IS EMPTY" % tableName)
#

func _sql_select(sql_query):
	db_sql = SQLite.new()
	db_sql.path = db_name
	db_sql.open_db()
	db_sql.query(sql_query)
	for i in range(0, db_sql.query_result.size()):
		var data = db_sql.query_result[i]
	return db_sql.query_result


func read_traits_for_ethnicity(ethnicity_identifier):
	var data = _sql_select("SELECT t.trait_identifier, t.trait_name, t.trait_description " +
	"FROM ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id " +
	"WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	db_sql.close_db()
	#print (data)
	return data


func read_attribute_data(attribute_identifier):
	var data = _sql_select("SELECT attribute_id, attribute_name, attribute_enum, bonus_value " +
	"FROM attributes  " +
	"WHERE attribute_identifier like '%s';" % attribute_identifier)
	db_sql.close_db()
#	print (data)
	return data[0]
	
	
func read_attributes_name_without_any():
	var data = _sql_select("SELECT attribute_name " +
	"FROM attributes  " +
	"WHERE attribute_identifier != 'Any';")
	db_sql.close_db()
#	print (data)
	return data	
	
	
func read_all_data():
	var data = _sql_select("SELECT e.ethnicity_id _id, e.ethnicity_identifier, " +
	"e.ethnicity_name, e.splash_art_path, e.ethnicity_description, " +
	"t.trait_id, t.trait_identifier, t.trait_name, t.trait_description, " +
	"a.attribute_id, a.attribute_identifier, a.attribute_name, a.attribute_enum, a.bonus_value " +
	"from ethnicities e JOIN attributes a on a.attribute_id = e.attribute_id " +
	"JOIN traits t on e.ethnicity_id = t.ethnicity_id;")
	db_sql.close_db()
	#print (data)
	return data


func read_ethnicity_identifiers():
	var data = _sql_select("SELECT ethnicity_identifier FROM ethnicities;")
	db_sql.close_db()
	#print (data)
	return data


func read_data_for_etnicity(ethnicity_identifier):
	var data = _sql_select("SELECT e.ethnicity_identifier, " +
	"e.ethnicity_name, e.splash_art_path, e.ethnicity_description, " +
	"a.attribute_identifier, a.attribute_name, a.attribute_enum, a.bonus_value " +
	"from ethnicities e JOIN attributes a on a.attribute_id = e.attribute_id " +
	"WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	db_sql.close_db()
	#print (data)
	return data[0]
	
	
func list_of_attributes():
	read_from_SQL()
	db_sql.open_db()
	var table_name = "attributes"
	var attributes = []
	var select_condition : String = "attribute_identifier != 'Any';"
	var selected_array : Array = db_sql.select_rows(table_name, select_condition, ["attribute_name"])
	for selected_row in selected_array:
		attributes.append(selected_row.get("attribute_name"))
#	print (attributes)
	return attributes


func list_of_traits():
	read_from_SQL()
	db_sql.open_db()
	var table_name = "traits"
	var traits = []
	var select_condition : String = "trait_identifier not in ('versatility_squared', 'versatility');"
	var selected_array : Array = db_sql.select_rows(table_name, select_condition, ["trait_name"])
	for selected_row in selected_array:
		traits.append(selected_row.get("trait_name"))
	print (traits)
	return traits
