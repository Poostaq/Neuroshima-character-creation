class_name Tooltip
extends Node


#####################################
# SIGNALS
#####################################

#####################################
# CONSTANTS
#####################################

#####################################
# EXPORT VARIABLES 
#####################################
export var visuals_res: PackedScene
export var owner_path: NodePath
export (float, 0, 10, 0.05) var delay = 0.5
export var follow_mouse: bool = true
export (float, 0, 100, 1) var offset_x
export (float, 0, 100, 1) var offset_y
export (float, 0, 100, 1) var padding_x
export (float, 0, 100, 1) var padding_y


#####################################
# PUBLIC VARIABLES 
#####################################

#####################################
# PRIVATE VARIABLES
#####################################
var _visuals: Control
var _timer: Timer
var _is_visuals_shown: bool


#####################################
# ONREADY VARIABLES
#####################################
onready var owner_node = get_node(owner_path)
onready var offset: Vector2 = Vector2(offset_x, offset_y)
onready var padding: Vector2 = Vector2(padding_x, padding_y)
onready var extents: Vector2


#####################################
# OVERRIDE FUNCTIONS
#####################################
func _init() -> void:
	pass


func _ready() -> void:
	_visuals = visuals_res.instance()
	add_child(_visuals)
	extents = _visuals.get_node("Text").rect_size
	
	owner_node.connect("mouse_entered", self, "_mouse_entered")
	owner_node.connect("mouse_exited", self, "_mouse_exited")
	
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_custom_show")
	_visuals.hide()


func _process(_delta: float) -> void:
	if self._is_visuals_shown:
		var border = get_viewport().size - padding
		extents = _visuals.get_node("Text").rect_size
		var base_pos = _get_screen_pos()
		# test if need to display to the left
		var final_x = base_pos.x + offset.x
		if final_x + extents.x > border.x:
			final_x = base_pos.x - offset.x - extents.x
		# test if need to display below
		var final_y = base_pos.y - extents.y - offset.y
		if final_y < padding.y:
			final_y = base_pos.y + offset.y
		_visuals.rect_position = Vector2(final_x, final_y)
		_visuals.show()


#####################################
# API FUNCTIONS
#####################################

#####################################
# HELPER FUNCTIONS
#####################################
func _mouse_entered() -> void:
	_timer.start(delay)


func _mouse_exited() -> void:
	_timer.stop()
	_is_visuals_shown = false
	_visuals.hide()


func _custom_show() -> void:
	_timer.stop()
	var text = _visuals.find_node("Text") as RichTextLabel
	text.bbcode_text = owner_node.get_tooltip_text()
	_is_visuals_shown = true


func _get_screen_pos() -> Vector2:
	if follow_mouse:
		return get_viewport().get_mouse_position()
	
	var position = Vector2()
	
	if owner_node is Node2D:
		position = owner_node.get_global_transform_with_canvas().origin
	elif owner_node is Spatial:
		position = get_viewport().get_camera().unproject_position(owner_node.global_transform.origin)
	elif owner_node is Control:
		position = owner_node.rect_position
	
	return position
