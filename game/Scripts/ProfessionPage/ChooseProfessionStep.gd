extends Control
 

signal profession_chosen()
signal profession_cleared()


export(ButtonGroup) var trait_group

var step_name = "profession_step_description"
var profession_list = []
var current_profession_index = 0
var profession = {}

onready var picture = $"%ProfessionPic"
onready var profession_name = $"%ProfessionName"
onready var profession_description = $"%ProfessionDescription"
onready var trait_container = $"%TraitContainer"
onready var profession_quote = $"%ProfessionQuote"

onready var trait_button_scene = preload("res://Scenes/ProfessionPage/ProfessionTrait.tscn")
onready var db = get_node("/root/DatabaseOperations")

func _ready():
	profession_list = db.read_profession_identifiers()
	profession = db.read_data_for_profession(profession_list[current_profession_index]["profession_identifier"])


func load_step() -> void:
	db.update_player_ethnicity(CharacterStats.player_id, CharacterStats.ethnicity_id, CharacterStats.ethnicity_trait_id)
	CharacterStats.update_attribute_values()
	_load_profession(profession)
	trait_group = load("res://Scenes/ProfessionPage/Traits.tres")


func clean_up_step() -> void:
	_changed_profession()


func _set_image(path) -> void:
	var image = load(path)
	if image == null:
		print("NO SUCH FILE: " + path)
	else:
		picture.texture = load(path)


func _load_profession(_profession) -> void:
	_set_image("res://Resources/ProfessionPage/splash_art/" + profession["splash_art_name"]) 
	profession_name.text = tr(profession["profession_name"])
	profession_description.bbcode_text = "%s" % tr(profession["profession_description"])
	profession_quote.bbcode_text = "[center]%s[/center]" % tr(profession["profession_quote"])
	var profession_trait_list = db.read_traits_for_profession(profession_list[current_profession_index]["profession_identifier"])
	if trait_container.get_child_count() > 0:
		for n in trait_container.get_children():
			trait_container.remove_child(n)
			n.queue_free()
	if len(profession_trait_list) == 2:
		_create_trait_list_filler()
	for trait in profession_trait_list:
		_create_trait_button(trait_button_scene, trait)
	if len(profession_trait_list) == 2:
		_create_trait_list_filler()

func _create_trait_list_filler() -> void:
		var control = Control.new()
		control.size_flags_horizontal = 3
		control.size_flags_vertical = 3
		control.size_flags_stretch_ratio = 0.5
		trait_container.add_child(control)


func _create_trait_button(trait_template, trait_data) -> void:
	var trait_button = trait_template.instance()
	trait_container.add_child(trait_button)
	trait_button.trait_name_label.bbcode_text = "[center]%s[/center]" % tr(trait_data["trait_name"])
	trait_button.trait_description_label.bbcode_text = "%s" % tr(trait_data["trait_short_description"])
	trait_button.connect("profession_trait_button_pressed", 
						self, 
						"_on_Trait_Button_button_pressed")
	trait_button.identifier = tr(trait_data["trait_identifier"])
	trait_button.trait_name = tr(trait_data["trait_name"])
	trait_button.description = tr(trait_data["trait_short_description"])
	trait_button.tooltip_text = tr(trait_data["trait_description"])
	trait_button.trait_id = trait_data["trait_id"]
	trait_button.get_node(".").set_button_group(trait_group)


func _on_Trait_Button_button_pressed(button) -> void:
	if CharacterStats.is_special_rules_profession_applied():
		for rule in CharacterStats.special_rules["Profession"]:
			rule.undo_perform_special_rule_action()
	var query = DatabaseOperations.get_special_rules_for_trait(button.trait_id)
	var special_rules = DatabaseOperations.create_special_rules_from_database_query_result(query)
	if special_rules:
		for rule in special_rules:
			rule.perform_special_rule_actions(button)
		CharacterStats.special_rules["Profession"] = special_rules
	emit_signal("profession_chosen")
	CharacterStats._on_ProfessionStep_profession_chosen(profession)
	CharacterStats._on_ProfessionStep_trait_chosen(button)


func _on_PreviousProfession_button_up() -> void:
	if current_profession_index == 0:
		current_profession_index = len(profession_list)-1
	else:
		current_profession_index -= 1
	profession = db.read_data_for_profession(profession_list[current_profession_index]["profession_identifier"])
	_load_profession(profession)
	_changed_profession()

func _on_NextProfession_button_up() -> void:
	if current_profession_index == len(profession_list)-1:
		current_profession_index = 0
	else:
		current_profession_index += 1
	profession = db.read_data_for_profession(profession_list[current_profession_index]["profession_identifier"])
	_load_profession(profession)
	_changed_profession()


func _changed_profession() -> void:
	emit_signal("profession_cleared")
	CharacterStats._on_ProfessionStep_clear_trait()
	CharacterStats._on_ProfessionStep_clear_profession()
