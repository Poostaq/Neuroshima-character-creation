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


func read_ethnicity_identifiers():
	var data = _sql_select("SELECT ethnicity_identifier FROM ethnicities;")
	db.close_db()
	return data


func read_traits_for_ethnicity(ethnicity_identifier):
	var data = _sql_select("SELECT t.trait_identifier, t.trait_name, t.trait_description " +
	"FROM ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id " +
	"WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
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


func read_profession_identifiers():
	var data = _sql_select("SELECT profession_identifier FROM professions;")
	db.close_db()
	return data
		
	
func read_traits_for_profession(profession_identifier):
	var data = _sql_select("SELECT t.trait_identifier, t.trait_name, t.trait_description " +
	"FROM professions p JOIN traits t on p.profession_id = t.profession_id " +
	"WHERE t.profession_identifier like '%s';" % profession_identifier)
	db.close_db()
	return data


func read_data_for_profession(profession_identifier):
	var data = _sql_select("SELECT profession_identifier, profession_name, " +
	"splash_art_path, profession_description from professions " +
	"WHERE profession_identifier like '%s';" % profession_identifier)
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


func read_list_of_ethnicity_traits_without_versatilities():
	read_from_SQL()
	db.open_db()
	var table_name = "traits"
	var traits = []
	var select_condition : String = "trait_identifier not in ('versatility_squared', 'versatility' " 
	select_condition += "and ethnicity_id is not null);"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["trait_name"])
	for selected_row in selected_array:
		traits.append(selected_row.get("trait_name"))
	return traits


func insert_into_player_info():
	pass


func update_player_info():
	pass


#	var row_array : Array = []
#	var row_dict : Dictionary = Dictionary()
#	for i in range(0,ids.size()):
#		row_dict["id"] = ids[i]
#		row_dict["name"] = names[i]
#		row_dict["age"] = ages[i]
#		row_dict["address"] = addresses[i]
#		row_dict["salary"] = salaries[i]
#		row_array.append(row_dict.duplicate())
#
#		# Insert a new row in the table
#		db.insert_row(table_name, row_dict)
#		row_dict.clear()
#	cprint(row_array)


#func add_item_quantity(amount_to_add):
#	item_quantity += amount_to_add
#	$Label.text = String((item_quantity))  
	
#func decrease_item_quantity(amount_to_remove):
#	item_quantity -= amount_to_remove
#	$Label.text = String(item_quantity)

#func test_dodanie_wartosci():
#db.update_rows(table_name, "name = 'Amanda'", {"AGE":30, "NAME":"Olga"})

#func test_dodanie_wartosci():
#	var player_table = "player_info"
#	read_from_SQL()
#	db.open_db()
#	db.update_rows(player_table, "(player_id = SELECT MAX(player_id) FROM player_info)", {"player_name" :"test" })
#	db.close_db()

func test_dodanie_wartosci():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
#	db.query("UPDATE player_info SET player_name = 'test2'")
	db.query("SELECT player_name FROM player_info where player_id = 1;")
#	db.query("SELECT ethnicity_name FROM ethnicities where ethnicity_id=1;")
	print (db.query_result)
	db.close_db()
	return db.query_result
#
#
#	read_from_SQL()
#	db.update_rows(player_table, "(player_id = SELECT MAX(player_id) FROM player_info)", {"player_name" :"test" })
#	db.close_db()
