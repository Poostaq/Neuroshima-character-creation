extends "res://EthnicityPage/EthnicityTrait.gd"

onready var option_button = $MarginContainer/VBoxContainer/OptionButton
export var secondary_trait: String

func _ready():
	pass

func _on_OptionButton_item_selected(index):
	secondary_trait = option_button.get_item_text(index)
	print(secondary_trait)
