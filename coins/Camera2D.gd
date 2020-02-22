extends Camera2D


onready var player = get_node("/root/MainScene/Player")


func _process(delta: float) -> void:
	position.x = player.position.x
