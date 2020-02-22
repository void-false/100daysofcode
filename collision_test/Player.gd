extends KinematicBody2D


var speed: int = 0
var accel: int = 10
var movement: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		self.position = event.position

func _process(delta: float) -> void:
	if is_on_floor():
		speed = 0
	movement = Vector2(0, speed)
	move_and_slide(movement, Vector2.UP)
	speed += accel

func kill() -> void:
	queue_free()
