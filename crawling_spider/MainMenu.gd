extends Node


func _ready() -> void:
	$"Control/MenuItems/Play".grab_focus()


func _on_Play_pressed() -> void:
	Globals.set_gamestate(Globals.GameState.LEVEL)
	get_tree().change_scene("res://Level1.tscn")
	

func _on_HighScore_pressed() -> void:
	get_tree().change_scene("res://HighScore.tscn")


func _on_Options_pressed() -> void:
	get_tree().change_scene("res://Options.tscn")


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://Credits.tscn")
