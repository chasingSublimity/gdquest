extends Area2D

func _on_area_entered(_area_that_entered: Area2D) -> void:
	queue_free()

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	pass
