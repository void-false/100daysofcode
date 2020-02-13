extends Sprite

signal checkpoint_activated

var activated: bool = false


func _ready() -> void:
	modulate = Color(0.6, 0.6, 0.6)


func change_state(active_name: String) -> void:
	if self.name == active_name:
		modulate = Color(1, 1, 1)
		activated = true
	else:
		modulate = Color(0.6, 0.6, 0.6)
		activated = false
			

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body and body.name == "Player":
		emit_signal("checkpoint_activated", transform.origin)
		get_tree().call_group("Checkpoints", "change_state", name)
		if not activated:
			$AudioStreamPlayer.play()

		
