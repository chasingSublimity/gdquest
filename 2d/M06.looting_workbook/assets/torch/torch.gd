extends Node2D

@onready var flame: Sprite2D = $Flame

func _ready() -> void:
	# This parameter of the shader material gives each flame a slightly different look and randomized animation.
	flame.material.set("shader_parameter/offset", global_position * 0.1)

func _toggle_torch_visibility():
	$Flame.visible = not $Flame.visible

func _input_event(viewport: Viewport, event: InputEvent, _shape_index: int):
	var is_mouse_left_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	
	if is_mouse_left_click:
		_toggle_torch_visibility();
