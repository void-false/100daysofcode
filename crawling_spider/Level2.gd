extends Node

func _ready() -> void:
	Globals.start_time = OS.get_ticks_msec()


func _on_BackToMenuTimer_timeout() -> void:
	get_tree().change_scene("res://MainMenu.tscn")


func _on_NextLevelTimer_timeout() -> void:
	get_tree().change_scene("res://EnterYourName.tscn")


func _on_RestartLevelTimer_timeout() -> void:
	get_tree().reload_current_scene()