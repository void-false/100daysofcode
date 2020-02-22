extends Area2D


export var value: int = 1


func _process(delta: float) -> void:
	rotation_degrees += 90 * delta


func _on_Coin_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.collect_coin(value)
		queue_free()
