extends Sprite2D # very similar to `require` or `import`

var normal_speed := 1200.0
var max_speed := normal_speed
var boost_speed := 3000.0

var velocity := Vector2(0, -0)

var steering_factor := 10.0 # higher factor == more responsive

# special function in godot that is called by the image every frame
func _process(delta: float) -> void:
	# init direction to a "no direction" vector
	var direction := Vector2(0,0)
	# map player input to direction elements
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		get_node("Timer").start()

	
	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	# calc velocity by multiplying player defined direction by max_speed constant
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta
	if direction.length() > 0.0:
		rotation = velocity.angle()


func _on_timer_timeout() -> void:
	max_speed = normal_speed
