extends Node2D

@onready var timer: Timer = $Timer
@onready var bird_sprite: Sprite2D = $Sparrow
@onready var shadow_sprite: Sprite2D = $Shadow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = randf_range(1.0, 3.0)
	timer.one_shot = true
	timer.timeout.connect(_hop)
	timer.start()


func _hop() -> void:
	const HOP_DURATION := 0.25
	const HALF_HOP_DURATION := HOP_DURATION / 2.0
	
	var random_direction := Vector2(1.0, 0.0).rotated(randf_range(0, 2 * PI))
	var land_position := random_direction * randf_range(0.0, 30.0)
	
	var tween := create_tween().set_parallel()
	tween.tween_property(bird_sprite, 'position:x', land_position.x, HOP_DURATION)
	tween.tween_property(shadow_sprite, 'position', land_position, HOP_DURATION)
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	const JUMP_HEIGHT := 16.0
	tween.tween_property(bird_sprite, "position:y", land_position.y - JUMP_HEIGHT, HALF_HOP_DURATION)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(bird_sprite, "position:y", land_position.y, HALF_HOP_DURATION)
	
	timer.wait_time = randf_range(1.0, 3.0)
	# I connect the tween's finished signal to the timer's start method. This way, the animation ends, there's a pause, and when the timer times out, the bird hops again.
	tween.finished.connect(timer.start)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
