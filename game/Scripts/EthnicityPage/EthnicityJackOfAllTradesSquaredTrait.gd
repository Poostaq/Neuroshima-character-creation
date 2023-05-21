extends "res://Scripts/EthnicityPage/EthnicityTrait.gd"

export var secondary_trait: String
export (NodePath) onready var option_button =  get_node(option_button) as OptionButton


func _on_OptionButton_item_selected(_index) -> void:
	secondary_trait = option_button.get_item_text(option_button.selected)
	emit_signal("trait_button_pressed", self)
	self.set_pressed(true)
