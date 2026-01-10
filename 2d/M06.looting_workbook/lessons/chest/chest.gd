extends Area2D

@export var possible_items: Array[PackedScene] = []

const STARTING_BORDER_THICKNESS: float = 5.0
const ENDING_BORDER_THICKNESS: float = 8.0

const FLIGHT_TIME := 0.4
const HALF_FLIGHT_TIME := FLIGHT_TIME / 2.0

@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	canvas_group.material.set_shader_parameter("line_thickness", STARTING_BORDER_THICKNESS)
	
func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, STARTING_BORDER_THICKNESS, ENDING_BORDER_THICKNESS, 0.08)

func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, ENDING_BORDER_THICKNESS, STARTING_BORDER_THICKNESS, 0.08)

func set_outline_thickness(new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_index: int):
	var event_is_left_mouse_click: bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
	)
	if event_is_left_mouse_click:
		open()
	pass

func open() -> void:
	animation_player.play("open")
	# any given chest should only be opennable once
	input_pickable = false
	
	if possible_items.is_empty():
		return
		
	for curr in range(randi_range(1,3)):
		_spawn_random_item()

func _spawn_random_item() -> void:
	var loot_item: Area2D = possible_items.pick_random().instantiate()
	add_child(loot_item)
	
	
	var random_angle := randf_range(0.0, 2.0 * PI)
	# Vector2(1.0, 0) represents the right direction (positive x axis), which is the reference point (0 radians) for angeles in godot
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	var random_distance := randf_range(60.0, 120.0)
	var land_position := random_direction * random_distance
	
	var tween := create_tween()
	tween.set_parallel()
	loot_item.scale = Vector2(0.25, 0.25)
	tween.tween_property(loot_item, "scale", Vector2(1.0, 1.0), HALF_FLIGHT_TIME)
	 #In animation code, we can use the colon : to separate a property name from a sub-property name.
	#It's a Godot convention to reference sub-properties with strings.
	tween.tween_property(loot_item, "position:x", land_position.x, FLIGHT_TIME)
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	var jump_height := randf_range(30.0, 80.0)
	tween.tween_property(loot_item, "position:y", land_position.y - jump_height, HALF_FLIGHT_TIME)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(loot_item, "position:y", land_position.y, HALF_FLIGHT_TIME)
