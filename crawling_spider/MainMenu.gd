extends Node


func _on_Play_pressed() -> void:
	get_tree().change_scene("res://Level1.tscn")


func _on_HighScore_pressed() -> void:
	get_tree().change_scene("res://HighScore.tscn")


func _on_Exit_pressed() -> void:
	get_tree().quit()
