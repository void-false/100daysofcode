extends Area2D

signal eaten

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Sprite.flip_h = randi() % 2


func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			emit_signal("eaten")
			queue_free()

