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
	var select = "SELECT ethnicity_identifier "
	var from = "FROM ethnicities;"
	var selected_array = _sql_select(select+from)
	db.close_db()
	return selected_array

	
func read_data_for_etnicity(ethnicity_identifier):
	var select = "SELECT e.ethnicity_identifier,e.ethnicity_name, " 
	select += "e.splash_art_path, e.ethnicity_description,a.attribute_identifier, "
	select += " a.attribute_name, a.attribute_enum, a.bonus_value "
	var from = "FROM ethnicities e JOIN attributes a on a.attribute_id = e.attribute_id "
	var where = ("WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array[0]


func read_traits_for_ethnicity(ethnicity_identifier):
	var select = "SELECT t.trait_identifier, t.trait_name, t.trait_description "
	var from = "FROM ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id "
	var where = ("WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array


func read_profession_identifiers():
	var select = "SELECT profession_identifier "
	var from = "FROM professions;"
	var selected_array = _sql_select(select+from)
	db.close_db()
	return selected_array


func read_data_for_profession(profession_identifier):
	var select = "SELECT profession_identifier, profession_name, " 
	select += "splash_art_path, profession_description "
	var from = "FROM professions "
	var where = ("WHERE profession_identifier like '%s';" % profession_identifier)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array[0]

	
func read_traits_for_profession(profession_identifier):
	var select = "SELECT t.trait_identifier, t.trait_name, t.trait_description "
	var from = "FROM professions p JOIN traits t on p.profession_id = t.profession_id "
	var where = "WHERE t.profession_id is not null and "
	where += ("t.profession_identifier like '%s';" % profession_identifier)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array
		

func read_list_of_ethnicity_traits_without_versatilities():
	read_from_SQL()
	var table_name = "traits"
	var traits = []
	var select_condition = "trait_identifier not in ('versatility_squared', 'versatility') "
	select_condition += "AND ethnicity_id is not null;"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["trait_name"])
	for selected_row in selected_array:
		traits.append(selected_row.get("trait_name"))
	db.close_db()
	return traits
	

func read_list_of_attributes_without_any():
	read_from_SQL()
	var table_name = "attributes"
	var attributes = []
	var select_condition = "attribute_identifier != 'Any';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["attribute_name"])
	for selected_row in selected_array:
		attributes.append(selected_row.get("attribute_name"))
	db.close_db()
	return attributes


func insert_into_player_info():
	read_from_SQL()
	var sysdate = datetime_to_string(OS.get_datetime())
	var columns = {"player_created_date" : sysdate}
	db.insert_rows("player_info", [columns])
	db.close_db()
	
	
func update_player_info(value):
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var sysdate = datetime_to_string(OS.get_datetime())
	var columns = {"player_name" :value, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()


func db_update_player_ethnicity(value):
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var sysdate = datetime_to_string(OS.get_datetime())
	var columns = {"player_ethnicity" :value, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()


func db_update_player_ethnicity_trait(value):
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var sysdate = datetime_to_string(OS.get_datetime())
	var columns = {"player_ethnicity_trait" :value, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()


func db_update_player_agility_bonus():
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"AGILITY" :1, "PERCEPTION" :0, "CHARACTER":0, "WITS":0, "BODY":0 }
	db.update_rows("player_info", condition, columns)
	db.close_db()
	
	
func db_update_player_perception_bonus():
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"AGILITY" :0, "PERCEPTION" :1, "CHARACTER":0, "WITS":0, "BODY":0 }
	db.update_rows("player_info", condition, columns)
	db.close_db()
	
	
func db_update_player_character_bonus():
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"AGILITY" :0, "PERCEPTION" :0, "CHARACTER":1, "WITS":0, "BODY":0 }
	db.update_rows("player_info", condition, columns)
	db.close_db()
	
	
func db_update_player_wits_bonus():
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"AGILITY" :0, "PERCEPTION" :0, "CHARACTER":0, "WITS":1, "BODY":0 }
	db.update_rows("player_info", condition, columns)
	db.close_db()
	
	
func db_update_player_body_bonus():
	read_from_SQL()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"AGILITY" :0, "PERCEPTION" :0, "CHARACTER":0, "WITS":0, "BODY":1 }
	db.update_rows("player_info", condition, columns)
	db.close_db()


func datetime_to_string(date):
	if (
		date.has("year")
		and date.has("month")
		and date.has("day")
		and date.has("hour")
		and date.has("minute")
		and date.has("second")
	):
		# Date and time.
		return "{year}-{month}-{day} {hour}:{minute}:{second}".format({
			year = str(date.year).pad_zeros(2),
			month = str(date.month).pad_zeros(2),
			day = str(date.day).pad_zeros(2),
			hour = str(date.hour).pad_zeros(2),
			minute = str(date.minute).pad_zeros(2),
			second = str(date.second).pad_zeros(2),
		})
	else :
		print ("Bad sysdate")
