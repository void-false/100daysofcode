extends Node


func _ready() -> void:
	$"VBoxContainer/BackButton".grab_focus()


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")

