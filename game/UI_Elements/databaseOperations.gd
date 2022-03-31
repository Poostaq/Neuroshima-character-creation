extends Node

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
