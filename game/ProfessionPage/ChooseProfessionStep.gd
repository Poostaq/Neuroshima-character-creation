extends Control
 

signal profession_chosen(current_profession)
signal trait_chosen(profession_trait_element)
signal clear_trait()


export(ButtonGroup) var trait_group


var profession_list = []
var current_profession = 0
var profession = {}


export (NodePath) onready var picture = get_node(picture) as TextureRect
export (NodePath) onready var profession_name = get_node(profession_name) as RichTextLabel
export (NodePath) onready var profession_description = get_node(profession_description) as RichTextLabel
export (NodePath) onready var trait_container =  get_node(trait_container) as HBoxContainer


onready var trait_button_scene = preload("res://ProfessionPage/ProfessionTrait.tscn")
onready var db = get_node("/root/DatabaseOperations")


func _ready():
	profession_list = db.read_profession_identifiers()
	profession = db.read_data_for_profession(profession_list[current_profession]["profession_identifier"])
	_load_profession(profession)
	trait_group = load("res://ProfessionPage/Traits.tres")
	yield(get_tree(), "idle_frame")
	emit_signal("profession_chosen", profession)


func _set_image(path):
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)


func _load_profession(_profession):
	_set_image(profession["splash_art_path"]) 
	profession_name.bbcode_text = "[center]%s[/center]" % profession["profession_name"]
	profession_description.bbcode_text = "%s" % profession["profession_description"] #.replace("\n", "\n")
	var profession_trait_list = db.read_traits_for_profession(profession_list[current_profession]["profession_identifier"])
	if trait_container.get_child_count() > 0:
		for n in trait_container.get_children():
			trait_container.remove_child(n)
			n.queue_free()
	for trait in profession_trait_list:
		_create_trait_button(trait_button_scene, trait)


func _create_trait_button(trait_template, trait_data):
	var trait_button = trait_template.instance()
	trait_container.add_child(trait_button)
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % trait_data["trait_name"]
	trait_button.trait_description_label.bbcode_text = "%s" % trait_data["trait_description"]
	trait_button.connect("profession_trait_button_pressed", 
						self, 
						"_on_Trait_Button_button_pressed")
	trait_button.ID = trait_data["trait_identifier"]
	trait_button.trait_name = trait_data["trait_name"]
	trait_button.description = trait_data["trait_description"]
	trait_button.get_node(".").set_button_group(trait_group)
	return trait_button


func _on_Trait_Button_button_pressed(button):
	emit_signal("trait_chosen", button)


func _on_PreviousProfession_button_up():
	if current_profession == 0:
		current_profession = len(profession_list)-1
	else:
		current_profession -= 1
	profession = db.read_data_for_profession(profession_list[current_profession]["profession_identifier"])
	_load_profession(profession)
	_changed_profession()

func _on_NextProfession_button_up():
	if current_profession == len(profession_list)-1:
		current_profession = 0
	else:
		current_profession += 1
	profession = db.read_data_for_profession(profession_list[current_profession]["profession_identifier"])
	_load_profession(profession)
	_changed_profession()


func _changed_profession():
	emit_signal("profession_chosen", profession)
	emit_signal("clear_trait")
