extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db
var db_local
var sysdate = _datetime_to_string(OS.get_datetime())

var main_db := "res://Database/neuroshima"
var packaged_main_db := "res://data_to_be_packaged"
var json_name := "res://Database/neuroshima_backup"


func open_connection_to(path) -> void:
	db = SQLite.new()
	db.path = path
	db.open_db()


func sql_command(query) -> Array:
	open_connection_to(main_db)
	db.query(query)
	return db.query_result


func read_ethnicity_identifiers() -> Array:
	var select = "SELECT ethnicity_identifier "
	var from = "FROM ethnicities;"
	var selected_array = sql_command(select+from)
	db.close_db()
	return selected_array

	
func read_data_for_etnicity(ethnicity_identifier: String) -> Dictionary:
	var select = "SELECT e.ethnicity_identifier,e.ethnicity_name, " 
	select += "e.splash_art_name, e.ethnicity_description,a.attribute_identifier, "
	select += " a.attribute_name, a.attribute_enum, a.bonus_value "
	var from = "FROM ethnicities e JOIN attributes a on a.attribute_id = e.attribute_id "
	var where = ("WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array[0]


func read_traits_for_ethnicity(ethnicity_identifier: String) -> Array:
	var select = "SELECT t.trait_id, t.trait_identifier, t.trait_name, t.trait_description, "
	select += "t.trait_short_description, t.trait_special_rules "
	var from = "FROM ethnicities e JOIN traits t on e.ethnicity_id = t.ethnicity_id "
	var where = ("WHERE e.ethnicity_identifier like '%s';" % ethnicity_identifier)
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array


func read_profession_identifiers() -> Array:
	var select = "SELECT profession_identifier "
	var from = "FROM professions;"
	var selected_array = sql_command(select+from)
	db.close_db()
	return selected_array


func read_data_for_profession(profession_identifier: String) -> Dictionary:
	var select = "SELECT profession_identifier, profession_name, " 
	select += "splash_art_name, profession_quote, profession_description "
	var from = "FROM professions "
	var where = ("WHERE profession_identifier like '%s';" % profession_identifier)
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array[0]

	
func read_traits_for_profession(profession_identifier: String) -> Array:
	var select = "SELECT t.trait_identifier, t.trait_name, t.trait_description, t.trait_short_description, t.trait_id "
	var from = "FROM professions p JOIN traits t on p.profession_id = t.profession_id "
	var where = "WHERE t.profession_id is not null and "
	where += ("p.profession_identifier like '%s';" % profession_identifier)
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array
	

func read_list_of_ethnicity_traits_without_versatilities() -> Array:
	open_connection_to(main_db)
	var table_name = "traits"
	var traits = []
	var select_condition = "trait_identifier not in ('versatility_squared', 'versatility') "
	select_condition += "AND ethnicity_id is not null;"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["trait_name"])
	for selected_row in selected_array:
		traits.append(selected_row.get("trait_name"))
	db.close_db()
	return traits


func read_list_of_attributes_without_any() -> Array:
	open_connection_to(main_db)
	var table_name = "attributes"
	var attributes = []
	var select_condition = "attribute_identifier != 'any';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["attribute_name"])
	for selected_row in selected_array:
		attributes.append(selected_row.get("attribute_name"))
	db.close_db()
	return attributes


func read_list_of_attribute_descriptions_without_any() -> Array:
	open_connection_to(main_db)
	var table_name = "attributes"
	var attributes = []
	var select_condition = "attribute_identifier != 'any';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["attribute_description"])
	for selected_row in selected_array:
		attributes.append(selected_row.get("attribute_description"))
	db.close_db()
	return attributes


func read_list_of_modifiers() -> Array:
	open_connection_to(main_db)
	var table_name = "test_modifiers"
	var modifiers = []
	var select_condition = "test_modifier_identifier not like '%master';"
	var selected_array : Array = db.select_rows(table_name, select_condition, ["modifier_value"])
	for selected_row in selected_array:
		modifiers.append(selected_row.get("modifier_value"))
	db.close_db()
	return modifiers


func insert_into_player_info() -> void:
	open_connection_to(main_db)
	var columns = {"player_created_date" : sysdate}
	db.insert_rows("player_info", [columns])
	db.close_db()


func update_player_info(value):
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var columns = {"player_name" :value, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()


func update_player_ethnicity(player_id: int, player_ethnicity: String, player_ethnicity_trait: String) -> void:
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(%s) FROM player_info))" % [player_id]
	var col = {"player_updated_date" :sysdate, "player_ethnicity":player_ethnicity,"player_ethnicity_trait":player_ethnicity_trait} 
	db.update_rows("player_info", condition, col)
	db.close_db()


func update_player_attribute_bonus(value):
	open_connection_to(main_db)
	var attribute = db.select_rows("attributes", "attribute_enum = " + str(value), ["attribute_identifier"])
	var uppper_attribute = (attribute[0]["attribute_identifier"].to_upper())
	var condition = "(player_id = (SELECT MAX(player_id) FROM player_info))"
	var col = {"AGILITY" :0, "PERCEPTION" :0, "CHARACTER":0, "WITS":0, "BODY":0 }
	col[uppper_attribute] = 1
	db.close_db()
	open_connection_to(main_db)
	db.update_rows("player_info", condition, col)
	db.close_db()


func update_player_profession(player_id: int, player_profession, player_profession_trait):
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(%s) FROM player_info))" % [player_id]
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


func read_specialization_identifiers():
	var select = "SELECT specialization_identifier "
	var from = "FROM specializations "
	var where = "WHERE specialization_enum is not null"
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array


func read_data_for_specialization(specialization_identifier):
	var select = "SELECT specialization_id , specialization_identifier, " 
	select += "specialization_name, specialization_description, specialization_enum "
	var from = "FROM specializations "
	var where = ("WHERE specialization_identifier like '%s';" % specialization_identifier)
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array[0]


func read_packs_for_specialization(specialization_identifier):
	var select = "SELECT sp.skill_pack_identifier, sp.skill_pack_name, attr.attribute_name, spec.specialization_identifier, spec.specialization_name " 
	var from = "FROM skill_packs sp "
	var join = "JOIN attributes attr on sp.attribute_id = attr.attribute_id "
	join += "JOIN specializations spec on sp.specialization_id = spec.specialization_id "
	var where = "WHERE spec.specialization_identifier like '%"+specialization_identifier+"%';"
	var selected_array = sql_command(select+from+join+where);
	db.close_db()
	return selected_array

func read_all_skill_packs():
	var select = "SELECT sp.skill_pack_identifier, sp.skill_pack_name, attr.attribute_name, spec.specialization_identifier, spec.specialization_name " 
	var from = "FROM skill_packs sp "
	var join = "JOIN attributes attr on sp.attribute_id = attr.attribute_id "
	join += "JOIN specializations spec on sp.specialization_id = spec.specialization_id "
	var selected_array = sql_command(select+from+join);
	db.close_db()
	return selected_array

func read_all_skill_packs_for_attribute(attribute):
	var select = "SELECT sp.skill_pack_identifier, sp.skill_pack_name, attr.attribute_name, spec.specialization_identifier, spec.specialization_name " 
	var from = "FROM skill_packs sp "
	var join = "JOIN attributes attr on sp.attribute_id = attr.attribute_id "
	join += "JOIN specializations spec on sp.specialization_id = spec.specialization_id "
	var where = "WHERE attr.attribute_name like '%"+attribute+"%';"
	var selected_array = sql_command(select+from+join+where);
	db.close_db()
	return selected_array

func read_all_skill_packs_for_all_atributes():
	var array = []
	for attribute in read_list_of_attributes_without_any():
		var database_query_result = read_all_skill_packs_for_attribute(attribute)
		array.append({"name": attribute,"skill_packs_data" : create_skill_packs_from_database_query_result(database_query_result)})
	return array

func read_skills_for_package(package_identifier, alternate_general_knowledge):
	var select = "SELECT s.skill_identifier, s.skill_name, s.skill_description, s.skill_special_rules,"
	select+= " s2.specialization_identifier, s2.specialization_name " 
	var from = "FROM skills s "
	var join = "JOIN skill_packs sp on s.skill_pack_id = sp.skill_pack_id "
	join += "JOIN specializations s2 on sp.specialization_id = s2.specialization_id "
	var where = ""
	if not alternate_general_knowledge:
		where = "WHERE s.skill_special_rules is null "
	else:
		where = "WHERE s.skill_special_rules is not null "
	where += ("AND sp.skill_pack_identifier like '%s';" % package_identifier)
	var selected_array = sql_command(select+from+join+where);
	db.close_db()
	var skill_list = []
	for record in selected_array:
		var skill_data = SkillData.new(record["skill_name"], 0, record["skill_identifier"], record["skill_description"])
		if record["skill_special_rules"]:
			skill_data.special_rules = record["skill_special_rules"] 
		skill_list.append(skill_data)
	return skill_list

func read_skills():
	var select = "SELECT s.skill_identifier, s.skill_name, s.attribute_id, s.skill_description, s.skill_special_rules " 
	var from = "FROM skills s "
	var selected_array = sql_command(select+from);
	db.close_db()
	var skill_list = []
	for record in selected_array:
		var skill_data = SkillData.new(record["skill_name"], 0, record["skill_identifier"], record["skill_description"])
		if record["skill_special_rules"]:
			skill_data.special_rules = record["skill_special_rules"] 
		skill_list.append(skill_data)
	return skill_list

func read_general_knowledge_skills():
	var select = "SELECT s.skill_identifier, s.skill_name, s.skill_description " 
	var from = "FROM skills s "
	var join = "JOIN skill_packs sp on s.skill_pack_id = sp.skill_pack_id "
	var where = "WHERE s.skill_special_rules is not null "
	var selected_array = sql_command(select+from+join+where);
	db.close_db()
	var skill_list = []
	for record in selected_array:
		print(record["skill_description"])
		var description = ""
		if record["skill_description"] != null:
			description = record["skill_description"]
		var skill_data = SkillData.new(record["skill_name"], 0, record["skill_identifier"], description)
		skill_list.append(skill_data)
	return skill_list
	
func get_languages_data():
	var select = "SELECT l.language_key, l.language_locale "
	var from = "FROM languages l"
	var selected_array = sql_command(select+from);
	db.close_db()
	return selected_array

func get_config_value(value: String):
	var select = "SELECT conf.config_attribute_name, conf.config_attribute_value, conf.config_attribute_default_value "
	var from = "FROM config conf "
	var where = "WHERE conf.config_attribute_name = '%s'" % value
	var selected_array = sql_command(select+from+where);
	db.close_db()
	return selected_array[0]

func save_config_value(config_name: String, value: String):
	var insert = "UPDATE config "
	var set = "SET config_attribute_value = '%s' " % value
	var where = "WHERE config_attribute_name = '%s'" % config_name
	var _result = sql_command(insert+set+where)

func create_skill_packs_from_database_query_result(database_query_result: Array):
	var skill_pack_dict = {}
	for record in database_query_result:
		var skill_pack_data = SkillPack.new(record["attribute_name"],record["skill_pack_identifier"], record["skill_pack_name"], record["specialization_identifier"], record["specialization_name"])
		var skills_data = read_skills_for_package(skill_pack_data.identifier, false)
		for element in skills_data:
			skill_pack_data.skill_data.append(element)
		skill_pack_dict[record["skill_pack_identifier"]] = skill_pack_data
	return skill_pack_dict

func get_special_rules_for_trait(trait_id: int) -> Array:
	var select = "SELECT * "
	var from = "FROM traits_special_rules tsr "
	var join = "JOIN traits t on t.trait_id  = tsr.trait_id "
	var where = "WHERE tsr.trait_id is not null "
	where += "AND t.trait_id like '%s'" % trait_id
	var selected_array = sql_command(select+from+join+where);
	db.close_db()
	return selected_array
	
func create_special_rules_from_database_query_result(database_query_result: Array):
	var special_rules_array = []
	for record in database_query_result:
		var special_rule = SpecialRule.new(record["trait_id"], record["trait_sr_name"], record["trait_sr_query"], record["trait_sr_value"])
		special_rules_array.append(special_rule)
	return special_rules_array
	
func create_general_knowledge_alternative_skill_pack() -> SkillPack:
	var select = "SELECT sp.skill_pack_identifier, sp.skill_pack_name, attr.attribute_name, spec.specialization_name, spec.specialization_identifier " 
	var from = "FROM skill_packs sp "
	var join = "JOIN attributes attr on sp.attribute_id = attr.attribute_id "
	join += "JOIN specializations spec on sp.specialization_id = spec.specialization_id "
	var where = "WHERE sp.skill_pack_identifier like 'general_knowledge' "
	var record = sql_command(select+from+join+where)[0]
	var skill_pack_data = SkillPack.new(record["attribute_name"],record["skill_pack_identifier"], record["skill_pack_name"], record["specialization_identifier"], record["specialization_name"])
	var skills_data = read_skills_for_package(skill_pack_data.identifier, true)
	for element in skills_data:
		skill_pack_data.skill_data.append(element)
	return skill_pack_data

func create_regular_general_knowledge_skill_pack() -> SkillPack:
	var select = "SELECT sp.skill_pack_identifier, sp.skill_pack_name, attr.attribute_name, spec.specialization_name, spec.specialization_identifier " 
	var from = "FROM skill_packs sp "
	var join = "JOIN attributes attr on sp.attribute_id = attr.attribute_id "
	join += "JOIN specializations spec on sp.specialization_id = spec.specialization_id "
	var where = "WHERE sp.skill_pack_identifier like 'general_knowledge' "
	var record = sql_command(select+from+join+where)[0]
	var skill_pack_data = SkillPack.new(record["attribute_name"],record["skill_pack_identifier"], record["skill_pack_name"], record["specialization_identifier"], record["specialization_name"])
	var skills_data = read_skills_for_package(skill_pack_data.identifier, false)
	for element in skills_data:
		skill_pack_data.skill_data.append(element)
	return skill_pack_data

func get_tricks_data_for_character_stats() -> Array:
	var query = """SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1
WHERE (select agility from player_info)>= t1.agility 
AND (select perception from player_info)>= t1.perception 
AND (select character from player_info)>= t1.character 
AND (select wits from player_info)>= t1.wits 
AND (select body from player_info)>= t1.body 
AND (select brawl from player_info)>= t1.brawl 
AND (select melee_weapon from player_info)>= t1.melee_weapon 
AND (select throwing from player_info)>= t1.throwing 
AND (select car from player_info)>= t1.car 
AND (select motorcycle from player_info)>= t1.motorcycle 
AND (select truck from player_info)>= t1.truck 
AND (select pickpocketing from player_info)>= t1.pickpocketing 
AND (select lockpicking from player_info)>= t1.lockpicking 
AND (select nimble_hands from player_info)>= t1.nimble_hands 
AND (select pistols from player_info)>= t1.pistols 
AND (select rifles from player_info)>= t1.rifles 
AND (select machine_gun from player_info)>= t1.machine_gun 
AND (select bow from player_info)>= t1.bow 
AND (select crossbow from player_info)>= t1.crossbow 
AND (select slingshot from player_info)>= t1.slingshot 
AND (select sense_of_direction from player_info)>= t1.sense_of_direction 
AND (select traps from player_info)>= t1.traps 
AND (select tracking from player_info)>= t1.tracking 
AND (select listening from player_info)>= t1.listening 
AND (select watching_out from player_info)>= t1.watching_out 
AND (select vigilance from player_info)>= t1.vigilance 
AND (select sneaking from player_info)>= t1.sneaking 
AND (select hiding from player_info)>= t1.hiding 
AND (select cloaking from player_info)>= t1.cloaking 
AND (select hunting from player_info)>= t1.hunting 
AND (select terrain_knowledge from player_info)>= t1.terrain_knowledge 
AND (select water_aquisition from player_info)>= t1.water_aquisition 
AND (select intimidation from player_info)>= t1.intimidation 
AND (select persuasion from player_info)>= t1.persuasion 
AND (select leadership_abilities from player_info)>= t1.leadership_abilities 
AND (select perceiving_emotions from player_info)>= t1.perceiving_emotions 
AND (select bluff from player_info)>= t1.bluff 
AND (select animal_care from player_info)>= t1.animal_care 
AND (select pain_resistance from player_info)>= t1.pain_resistance 
AND (select steadfastness from player_info)>= t1.steadfastness 
AND (select morale from player_info)>= t1.morale 
AND (select first_aid from player_info)>= t1.first_aid 
AND (select wound_healing from player_info)>= t1.wound_healing 
AND (select disease_treatment from player_info)>= t1.disease_treatment 
AND (select mechanics from player_info)>= t1.mechanics 
AND (select electronics from player_info)>= t1.electronics 
AND (select computers from player_info)>= t1.computers 
AND (select general_knowledge_1 from player_info)>= t1.general_knowledge_1
AND (select general_knowledge_2 from player_info)>= t1.general_knowledge_2
AND (select general_knowledge_3 from player_info)>= t1.general_knowledge_3
AND (select history from player_info)>= t1.history
AND (select geography from player_info)>= t1.geography
AND (select biology from player_info)>= t1.biology
AND (select surgery from player_info)>= t1.surgery
AND (select physics from player_info)>= t1.physics
AND (select mathematics from player_info)>= t1.mathematics
AND (select chemistry from player_info)>= t1.chemistry
AND (select psychology from player_info)>= t1.psychology
AND (select heavy_machinery from player_info)>= t1.heavy_machinery 
AND (select combat_vehicles from player_info)>= t1.combat_vehicles 
AND (select boats from player_info)>= t1.boats 
AND (select gunsmithing from player_info)>= t1.gunsmithing 
AND (select launchers from player_info)>= t1.launchers 
AND (select explosives from player_info)>= t1.explosives 
AND (select fitness from player_info)>= t1.fitness 
AND (select swimming from player_info)>= t1.swimming 
AND (select climbing from player_info)>= t1.climbing 
AND (select horse_riding from player_info)>= t1.horse_riding 
AND (select carriage_driving from player_info)>= t1.carriage_driving 
AND (select wild_ride from player_info)>= t1.wild_ride UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'feint' AND (select melee_weapon from player_info UNION select brawl from player_info order by 1 desc )>= t2.trick_sr_value
AND (select wits from player_info)>= t1.wits UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'makeshift' AND (select mechanics  from player_info UNION select electronics  from player_info order by 1 desc )>= t2.trick_sr_value UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'chess_player' AND (select melee_weapon from player_info UNION select brawl from player_info order by 1 desc )>= t2.trick_sr_value
AND (select wits from player_info)>= t1.wits UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'ramming' AND (select truck from player_info UNION select car from player_info order by 1 desc )>= t2.trick_sr_value UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'making_arrows_or_bolts' AND (select bow from player_info UNION select crossbow from player_info order by 1 desc )>= t2.trick_sr_value
AND (select wits from player_info)>= t1.wits UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'wait_out' AND (select brawl from player_info UNION select melee_weapon from player_info order by 1 desc )>= t2.trick_sr_value
AND (select perception from player_info)>= t1.perception UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'glance' AND (select mechanics from player_info UNION select electronics from player_info order by 1 desc )>= t2.trick_sr_value
AND (select wits from player_info)>= t1.wits UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'mobile_target' AND (select pistols from player_info UNION select rifles from player_info UNION 
select machine_gun from player_info order by 1 desc)>= t2.trick_sr_value AND (select wits from player_info)>= t1.wits AND (select perception from player_info)>= t1.perception UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'tune_up' AND (select mechanics from player_info UNION select electronics from player_info order by 1 desc )>= t2.trick_sr_value
AND (select wits from player_info)>= t1.wits UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'plug&play' AND (select combat_vehicles from player_info UNION select heavy_machinery from player_info order by 1 desc )>= t2.trick_sr_value
AND (select computers from player_info)>= t1.agility UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'surehand' AND (select rifles from player_info UNION select pistols from player_info order by 1 desc )>= t2.trick_sr_value
AND (select character from player_info)>= t1.character AND (select agility from player_info)>= t1.agility UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'octopus' AND (select brawl from player_info UNION select melee_weapon from player_info order by 1 desc )>= t2.trick_sr_value 
AND (select wits from player_info)>= t1.wits AND (select fitness from player_info)>= t1.fitness UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'teacher' AND (select history from player_info UNION select geography from player_info UNION select biology from player_info 
UNION select surgery from player_info UNION select physics from player_info UNION select mathematics from player_info UNION select chemistry from player_info
UNION select psychology from player_info UNION select general_knowledge_1 from player_info UNION select general_knowledge_2 from player_info 
UNION select general_knowledge_3 from player_info order by 1 desc)>= t2.trick_sr_value UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'think_like_a_machine' AND (select electronics from player_info UNION select mechanics from player_info order by 1 desc )>= t2.trick_sr_value 
AND (select perceiving_emotions from player_info)>= t1.perceiving_emotions UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'drawing' AND (select pistols from player_info UNION select nimble_hands from player_info order by 1 desc )>= t2.trick_sr_value
AND (select agility from player_info)>= t1.agility UNION
SELECT t1.trick_id, trick_name, trick_requirements, trick_behaviour FROM tricks t1 LEFT JOIN tricks_special_rules t2 on t1.trick_id = t2.trick_id 
WHERE t2.trick_identifier like 'four_tankmen' AND (select heavy_machinery from player_info UNION select combat_vehicles from player_info order by 1 desc)>=t2.trick_sr_value
AND (select animal_care from player_info)>= t1.animal_care order by 1 asc;"""
	var records = sql_command(query)
	return records


func get_trick_by_name(trick_name: String) -> Trick:
	var select = "SELECT trick_id, trick_name, trick_requirements, trick_description, trick_behaviour "
	var from = "FROM tricks "
	var where = "WHERE trick_name = '%s'" % trick_name
	var record = sql_command(select+from+where)[0]
	var new_trick = Trick.new(record["trick_id"],
								record["trick_name"], 
								record["trick_description"],
								record["trick_behaviour"],
								record["trick_requirements"])
	db.close_db()
	return new_trick
	

func get_trick_actions(trick_id: int) -> Array:
	var select = "SELECT ta.trick_action_name, ta.trick_action_description " 
	var from = "FROM tricks_actions ta "
	var where = "WHERE ta.trick_id = %s" % trick_id
	var selected_array = sql_command(select+from+where)
	db.close_db()
	return selected_array


func create_new_character_entry() -> void:
	var insert = "INSERT INTO player_info DEFAULT VALUES; "
	var _query_result = sql_command(insert)
	db.close_db()

func return_current_player_id() -> int:
	var select = "SELECT MAX(player_id) as player_id FROM player_info"
	var query_result = sql_command(select)
	db.close_db()
	return query_result[0]["player_id"]

func set_creation_date(player_id: int) -> void:
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(%s) FROM player_info))" % [player_id]
	var columns = {"player_created_date" :sysdate, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()
	

func update_attribute_value(player_id: int, attribute_name: String, attribute_value: int) -> void:
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(%s) FROM player_info))" % [player_id]
	var columns = {attribute_name : attribute_value, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()
	
func update_player_specialization(player_id: int, specialization_identifier: String) -> void:
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(%s) FROM player_info))" % [player_id]
	var columns = {"player_specjalization" : specialization_identifier, "player_updated_date" :sysdate}
	db.update_rows("player_info", condition, columns)
	db.close_db()
	
func update_player_skill_levels(player_id: int, skill_data_dict) -> void:
	open_connection_to(main_db)
	var condition = "(player_id = (SELECT MAX(%s) FROM player_info))" % [player_id]
	print(skill_data_dict)
	skill_data_dict.merge({"player_updated_date" :sysdate})
	db.update_rows("player_info", condition, skill_data_dict)
	db.close_db()
	
