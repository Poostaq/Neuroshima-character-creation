extends Control

onready var picture = $VBoxContainer/HBoxContainer/MarginContainer/EthnicityPic
onready var ethnicity_name = $VBoxContainer/HBoxContainer2/EthnicityName
onready var ethnicity_description = $VBoxContainer/HBoxContainer/VBoxContainer/EthnicityDescription
onready var trait1name = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button/MarginContainer/VBoxContainer/TraitName
onready var trait1description = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button/MarginContainer/VBoxContainer/TraitDescription
onready var trait2name = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button2/MarginContainer/VBoxContainer/TraitName
onready var trait2description = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button2/MarginContainer/VBoxContainer/TraitDescription
onready var trait3name = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button3/MarginContainer/VBoxContainer/TraitName
onready var trait3description = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Button3/MarginContainer/VBoxContainer/TraitDescription


onready var database = get_node("/root/DatabaseOperations")

var ethnicity_list = []
var ethnicities = []
var current_ethnicity = 0


func _ready():
	var db = database.read_database_file()
	var sheets = db["sheets"]
	for sheet in sheets:
		if sheet["name"] == "ethnicity":
			ethnicities = sheet["lines"]
	load_ethnicity(ethnicities[current_ethnicity])


func _set_image(path):
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = ImageTexture.new()
		picture.texture.create_from_image(image, 0)



func load_ethnicity(ethnicity):
	_set_image(ethnicity["SplashArtPath"])
	ethnicity_name.bbcode_text = "[center]%s[/center]" % ethnicity["Name"]
	ethnicity_description.bbcode_text = "%s" % ethnicity["Description"]
	trait1name.bbcode_text = "[center]%s[/center]" % ethnicity["Trait1Name"]
	trait1description.bbcode_text = "%s" % ethnicity["Trait1Description"]
	trait2name.bbcode_text = "[center]%s[/center]" % ethnicity["Trait2Name"]
	trait2description.bbcode_text = "%s" % ethnicity["Trait2Description"]
	trait3name.bbcode_text = "[center]%s[/center]" % ethnicity["Trait3Name"]
	trait3description.bbcode_text = "%s" % ethnicity["Trait3Description"]



func _on_PreviousEthnicity_button_up():
	if current_ethnicity == 0:
		current_ethnicity = len(ethnicities)-1
	else:
		current_ethnicity -= 1
	load_ethnicity(ethnicities[current_ethnicity])


func _on_NextEthnicity_button_up():
	if current_ethnicity == len(ethnicities)-1:
		current_ethnicity = 0
	else:
		current_ethnicity += 1
	load_ethnicity(ethnicities[current_ethnicity])
