extends Control

export (NodePath) onready var card_button = get_node(card_button) as TextureButton
export (NodePath) onready var character_sheet_panel = get_node(character_sheet_panel) as Control
export (NodePath) onready var ethnicity_element = get_node(ethnicity_element) as Control
export (NodePath) onready var profession_element = get_node(profession_element) as Control

func _ready():
	pass
	

func _on_CardButton_button_up():
	character_sheet_panel.visible = true
	character_sheet_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	character_sheet_panel.update_card()


func _on_EthnicityStep_button_up():
	ethnicity_element.visible = true
	profession_element.visible = false
	ethnicity_element.mouse_filter = Control.MOUSE_FILTER_PASS


func _on_ProfessionStep_button_up():
	profession_element.visible = true
	ethnicity_element.visible = false
	profession_element.mouse_filter = Control.MOUSE_FILTER_PASS
