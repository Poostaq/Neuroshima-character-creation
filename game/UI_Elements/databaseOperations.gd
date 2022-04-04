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
		
func cprint(text : String) -> void:
	print(text)
	
#func test_read_SQL():
#	read_from_SQL()
#	db_sql.open_db()
#	var select_condition : String = "ethnicity_identifier is not null "
#	select_condition += "AND ethnicity_name not like 'Nie twój zasrany interes'"
#	var selected_array : Array = db_sql.select_rows(table_name, select_condition, ["ethnicity_identifier","ethnicity_name","splash_art_path" ])
#	cprint("condition: " + select_condition)
#	cprint("result: {0}".format([String(selected_array)]))
#	return db_sql.query_result


#	db_sql.open_db()
#	db_sql.query("select * from " + table_name + ";")
#	for i in range(0, db_sql.query_result.size()):
#		print("Identyfikator ", db_sql.query_result[i]["ethnicity_identifier"], 
#		", ", "SAP : ",db_sql.query_result[i]["splash_art_path"])

#func read_table_SQL():
#	read_from_SQL()
#	db_sql.query("SELECT e.ethnicity_id _id, e.ethnicity_identifier, " +
#	"e.ethnicity_name, e.splash_art_path, e.ethnicity_description, " +
#	"t.trait_id, t.trait_identifier, t.trait_name, t.trait_description, " +
#	"a.attribute_id, a.attribute_identifier, a.attribute_name, a.attri " +
#	"from ethnicities e JOIN attributes a on a.attribute_id = e.attribute_id " +
#	"JOIN traits t on e.ethnicity_id = t.ethnicity_id;")
#	for i in range(0, db_sql.query_result.size()):
#		var data = db_sql.query_result[i]
#		print ("Query results ", data)
#	return db_sql.query_result
	
	
#	var select_condition : String = "ethnicity_identifier like 'southern_hegemony'"
#	var selected_array : Array = db_sql.select_rows(table_name, select_condition, ["ethnicity_id",
#	"ethnicity_identifier","ethnicity_name","ethnicity_description","attribute_id","splash_art_path"])
#	cprint("condition: " + select_condition)
#	cprint("result: {0}".format([String(selected_array)]))
#	print (selected_array)
#	return selected_array
	
#func read_traits_for_ethnicity(ethnicity_identifier):
#	read_from_SQL()
#	db_sql = SQLite.new()
#	db_sql.path = db_name
#	db_sql.open_db()
#	db_sql.query("SELECT t.trait_identifier, t.trait_name, t.trait_description " +
#	"from ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id " +
#	"Where e.ethnicity_identifier like '%s';" % ethnicity_identifier)
#	for i in range(0, db_sql.query_result.size()):
#		var data = db_sql.query_result[i]
#	db_sql.close_db()
#	return db_sql.query_result

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
	"from ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id " +
	"Where e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	db_sql.close_db()
	return data
