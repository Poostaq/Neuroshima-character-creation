extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_local
var sysdate = _datetime_to_string(OS.get_datetime())

var db_name := "res://datastore/neuroshima"
var db_local_name := "res://datastore/local_player"
var packaged_db_name := "res://data_to_be_packaged"
var json_name := "res://datastore/neuroshima_backup"

func read_from_SQL():
	db = SQLite.new()
	db.path = db_name
	db.open_db()


func read_from_local_db():
	db = SQLite.new()
	db.path = db_local_name
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
	select += "splash_art_path, profession_quote, profession_description "
	var from = "FROM professions "
	var where = ("WHERE profession_identifier like '%s';" % profession_identifier)
	var selected_array = _sql_select(select+from+where)
	db.close_db()
	return selected_array[0]

	
func read_traits_for_profession(profession_identifier):
	var select = "SELECT t.trait_identifier, t.trait_name, t.trait_description "
	var from = "FROM professions p JOIN traits t on p.profession_id = t.profession_id "
	var where = "WHERE t.profession_id is not null and "
	where += ("p.profession_identifier like '%s';" % profession_identifier)
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
	var select_condition = "attribute_identifier != 'any';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["attribute_name"])
	for selected_row in selected_array:
		attributes.append(selected_row.get("attribute_name"))
	db.close_db()
	return attributes


func read_list_of_modifiers():
	read_from_SQL()
	var table_name = "test_modifiers"
	var modifiers = []
	var select_condition = "test_modifier_identifier not like '%master';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["modifier_value"])
	for selected_row in selected_array:
		modifiers.append(selected_row.get("modifier_value"))
	db.close_db()
	return modifiers


func insert_into_player_info():
	read_from_local_db()
	var columns = {"player_created_date" : sysdate}
	db.insert_rows("player_info", [columns])
	db.close_db()


func update_player_info(value):
	read_from_local_db()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"player_name" :value, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()


func db_update_player_ethnicity(player_ethnicity, player_ethnicity_trait):
	read_from_local_db()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var col = {"player_updated_date" :sysdate, "player_ethnicity":player_ethnicity,"player_ethnicity_trait":player_ethnicity_trait} 
	db.update_rows("player_info", condition, col)
	db.close_db()


func db_update_player_attribute_bonus(value):
	read_from_SQL()
	var attribute = db.select_rows("attributes", "attribute_enum = " + str(value), ["attribute_identifier"])
	var uppper_attribute = (attribute[0]["attribute_identifier"].to_upper())
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var col = {"AGILITY" :0, "PERCEPTION" :0, "CHARACTER":0, "WITS":0, "BODY":0 }
	col[uppper_attribute] = 1
	db.close_db()
	read_from_local_db()
	db.update_rows("player_info", condition, col)
	db.close_db()


func db_update_player_profession(player_profession, player_profession_trait):
	read_from_local_db()
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var col = {"player_updated_date" :sysdate, "player_profession":player_profession,"player_profession_trait":player_profession_trait }
	db.update_rows("player_info", condition, col)
	db.close_db()


func _datetime_to_string(date):
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
