extends Area2D

signal eaten

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Sprite.flip_h = randi() % 2


func _on_Fly_body_entered(body: Node) -> void:
	if "Player" in body.name:
			emit_signal("eaten")
			queue_free()
