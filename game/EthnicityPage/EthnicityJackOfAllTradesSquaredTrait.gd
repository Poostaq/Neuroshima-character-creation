extends "res://EthnicityPage/EthnicityTrait.gd"

export var secondary_trait: String
onready var option_button = $MarginContainer/VBoxContainer/OptionButton


func _on_OptionButton_item_selected(index):
	secondary_trait = option_button.get_item_text(index)
