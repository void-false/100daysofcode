extends Node


func _ready() -> void:
	randomize()
	for i in range(1, 11):
		var name : String = get_random_name()
		get_node("VBoxContainer/Row" + String(i) + "/NameLabel").text = name
		get_node("VBoxContainer/Row" + String(i) + "/ScoreLabel").text = String(10000 / (i*i))
		
	print(Globals.score)


func get_random_name() -> String:
	var name : PoolByteArray
	var max_letters : int = randi() % 13 + 1
	for i in range(max_letters):
		name.append(65 + randi() % 26)

	return name.get_string_from_ascii()


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")
