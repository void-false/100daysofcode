extends Area2D


export var speed: int = 100
export var move_dist: int = 100

onready var start_x: float = position.x
onready var target_x: float = position.x + move_dist


func _physics_process(delta: float) -> void:
	position.x = move_to(position.x, target_x, speed * delta)
	
	if position.x == target_x:
		if target_x == start_x:
			target_x = position.x + move_dist
		else:
			target_x = start_x
	
	
func move_to(current: float, to: float, step: float):
	var new: float = current
	
	if new < to:
		new += step
		if new > to:
			new = to
	else:
		new -= step
		if new < to:
			new = to
	return new


func _on_Enemy_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()
