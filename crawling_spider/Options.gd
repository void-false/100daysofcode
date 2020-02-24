extends Node


func _ready() -> void:
	$"VBoxContainer/BackButton".grab_focus()


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !button_pressed)
