#ANCHOR:extends
extends CharacterBody2D
#END:extends

#ANCHOR:preloads_essentials
const RUNNER_DOWN = preload("uid://c0i1ik45p7rhh")
const RUNNER_DOWN_RIGHT = preload("uid://cst3aklarj68")
const RUNNER_RIGHT = preload("uid://b4etxv4c5w1mq")
const RUNNER_UP = preload("uid://dtrvq16cx035")
const RUNNER_UP_RIGHT = preload("uid://c7x3s5c2r5l86")
#END:preloads_essentials
#ANCHOR:preloads_superfluous
const RUNNER_DOWN_LEFT = preload("uid://bork38ywg3paf")
const RUNNER_LEFT = preload("uid://bk7kvspkijqac")
const RUNNER_UP_LEFT = preload("uid://b5yil62vnj1o7")
#END:preloads_superfluous

#ANCHOR:max_speed
var max_speed := 600.0
#END:max_speed

#ANCHOR:node
@onready var _skin: Sprite2D = %Skin
#END:node

#ANCHOR:movement
#ANCHOR:physics_process_definition
func _physics_process(_delta: float) -> void:
#END:physics_process_definition
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * max_speed
	move_and_slide()
#END:movement
#ANCHOR:directions_first_two
	if direction.x > 0.0 and direction.y > 0.0:
		_skin.texture = RUNNER_DOWN_RIGHT
	elif direction.x < 0.0 and direction.y > 0.0:
		_skin.texture = RUNNER_DOWN_LEFT
#END:directions_first_two
#ANCHOR:directions_last
	elif direction.x > 0.0 and direction.y < 0.0:
		_skin.texture = RUNNER_UP_RIGHT
	elif direction.x < 0.0 and direction.y < 0.0:
		_skin.texture = RUNNER_UP_LEFT
	elif direction.x > 0.0:
		_skin.texture = RUNNER_RIGHT
	elif direction.x < 0.0:
		_skin.texture = RUNNER_LEFT
	elif direction.y > 0.0:
		_skin.texture = RUNNER_DOWN
	elif direction.y < 0.0:
		_skin.texture = RUNNER_UP
#END:directions_last
