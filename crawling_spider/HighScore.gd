extends Node


func _ready() -> void:
	$"VBoxContainer/BackButton".grab_focus()
	var high_score = Globals.high_score
	for i in len(high_score):
		get_node("VBoxContainer/Row" + String(i+1) + "/NameLabel").text = String(high_score[i][1])
		get_node("VBoxContainer/Row" + String(i+1) + "/ScoreLabel").text = String(high_score[i][0])


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")

