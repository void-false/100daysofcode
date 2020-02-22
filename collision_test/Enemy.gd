extends Area2D


var dir: int = 1
var speed: int = 100


func _process(delta: float) -> void:
	position.x += dir * speed * delta


func _on_Enemy_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.kill()
	dir *= -1
