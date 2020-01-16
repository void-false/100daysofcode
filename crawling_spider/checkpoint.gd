extends Sprite

signal activate_checkpoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color(0.6, 0.6, 0.6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body and body.name == "Player":
		emit_signal("activate_checkpoint", transform.origin)
		modulate = Color(1, 1, 1)
