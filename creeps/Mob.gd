extends RigidBody2D


export var min_speed: int = 150
export var max_speed: int = 250
var mob_types: Array = ["walk", "swim", "fly"]


func _ready() -> void:
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_Visibility_screen_exited() -> void:
	queue_free()


func _on_start_game() -> void:
	queue_free()
