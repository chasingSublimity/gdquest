extends Area2D

var gem_count := 0

var max_speed := 1200.0
var velocity := Vector2(0, 0)
var steering_factor := 3.0

var health := 100

func _process(delta: float) -> void:
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction.length() > 1.0:
		direction = direction.normalized()

	var desired_velocity := max_speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * steering_factor * delta
	position += velocity * delta

	if velocity.length() > 0.0:
		get_node("Sprite2D").rotation = velocity.angle()
		
	
	# wrap position
	var viewport_size := get_viewport_rect().size
	position.x = wrapf(position.x, 0, viewport_size.x + 60)
	position.y = wrapf(position.y, 0, viewport_size.y + 60)
	
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	get_node("UI/HealthBar/HealthDegradationTimer").timeout.connect(_on_health_degradation_timeout)
	set_health(100)

func set_health(new_health: int) -> void:
	health = new_health
	get_node("UI/HealthBar").value = health

func set_gem_count(new_gem_count: int) -> void:
	gem_count = new_gem_count
	get_node("UI/GemCount").text = "x" + str(gem_count)

func _on_area_entered(_area_that_entered: Area2D) -> void:
	if _area_that_entered.is_in_group("healing_item"):
		set_health(health + 20)
	elif _area_that_entered.is_in_group("gem"):
		set_gem_count(gem_count + 1)

func _on_health_degradation_timeout() -> void:
	set_health(health - 10)
