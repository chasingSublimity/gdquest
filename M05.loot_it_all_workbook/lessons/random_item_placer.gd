extends Node2D

const MAX_ITEMS := 6
var current_item_count := 0

var item_scenes := [
	preload("gem.tscn"), # preload returns a PackedScene
	preload("health_pack.tscn")
]

func _ready() -> void:
	get_node("Timer").timeout.connect(_on_timer_timeout)
	
func _on_tree_exited() -> void:
	current_item_count -= 1


func _on_timer_timeout() -> void:
	if current_item_count < MAX_ITEMS:
		var random_item_scene: PackedScene = item_scenes.pick_random()
		var item_instance := random_item_scene.instantiate()
		add_child(item_instance)
		
		# register exit hook to decrement current item count
		item_instance.tree_exited.connect(_on_tree_exited)
		
		var viewport_size := get_viewport_rect().size
		var random_position := Vector2(0, 0)
		random_position.x = randf_range(0.0, viewport_size.x - 30)
		random_position.y = randf_range(0.0, viewport_size.y - 30)
		
		item_instance.position = random_position
		current_item_count += 1
	else:
		# NOOP, we're at the item limit
		pass
