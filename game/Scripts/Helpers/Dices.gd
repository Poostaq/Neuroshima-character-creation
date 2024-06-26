extends Node

onready var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func roll_dice(dice_amount : int, dice_sides: int) -> Array:
	var results = []
	for roll in dice_amount:
		results.append(rng.randi_range(1,dice_sides))
	return results

