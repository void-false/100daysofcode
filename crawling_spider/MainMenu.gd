extends Node


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Play_pressed() -> void:
	get_tree().change_scene("res://Level1.tscn")
