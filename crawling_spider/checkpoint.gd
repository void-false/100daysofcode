extends Sprite

signal activate_checkpoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		emit_signal("activate_checkpoint", transform.origin)
