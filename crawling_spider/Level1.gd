extends Node

func _ready() -> void:
	Globals.start_time = OS.get_ticks_msec()


func _on_BackToMenuTimer_timeout() -> void:
	get_tree().change_scene("res://MainMenu.tscn")


func _on_HighScoreTimer_timeout() -> void:
	get_tree().change_scene("res://Level2.tscn")
