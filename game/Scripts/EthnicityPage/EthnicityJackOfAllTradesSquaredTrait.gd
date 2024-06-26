extends "res://Scripts/EthnicityPage/EthnicityTrait.gd"

export var secondary_trait: String
onready var option_button =  $"%TraitSelectionButton"


func _on_OptionButton_item_selected(index) -> void:
	secondary_trait = option_button.get_item_text(index)
	emit_signal("trait_button_pressed", self)
	self.set_pressed(true)
