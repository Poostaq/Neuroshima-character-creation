extends "res://EthnicityPage/EthnicityTrait.gd"
signal ethnicity_secondary_trait_chosen(button)

export var secondary_trait: String
onready var option_button = $MarginContainer/VBoxContainer/OptionButton


func _on_OptionButton_item_selected(index):
	secondary_trait = option_button.get_item_text(index)
	emit_signal("ethnicity_secondary_trait_chosen", self)
