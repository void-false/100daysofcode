extends Area2D

var dir: int = -1
var speed = 200
signal hit_player


func _ready() -> void:
	$AnimationPlayer.playback_speed = 3
	

func _physics_process(delta: float):
	move_loop(delta)


func move_loop(delta: float):
	position.x += dir * speed * delta


func _on_Wasp_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.kill()
	else:
		dir *= -1
		$Sprite.flip_h = !$Sprite.flip_h
