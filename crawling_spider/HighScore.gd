extends Node

class MyCustomSorter:
	static func sort(a, b):
		return a[0] > b[0]

func _ready() -> void:
	$"VBoxContainer/BackButton".grab_focus()
	
	var high_score =  [[500, "void"], [500, "void"], [200, "false"], [400, "linux"], [200, "false"], [200, "false"], [100, "macos"], [300, "godot"], [9000, "go sux"], [9000, "go sux"], [9000, "go sux"]]
	high_score.sort_custom(MyCustomSorter, "sort")
	high_score.resize(10)
	for i in len(high_score):
		
		get_node("VBoxContainer/Row" + String(i+1) + "/NameLabel").text = String(high_score[i][1]).to_upper()
		get_node("VBoxContainer/Row" + String(i+1) + "/ScoreLabel").text = String(high_score[i][0]).to_upper()



func test_high_score() -> void:
	randomize()
	for i in range(1, 11):
		var name : String = get_random_name()
		get_node("VBoxContainer/Row" + String(i) + "/NameLabel").text = name
		get_node("VBoxContainer/Row" + String(i) + "/ScoreLabel").text = String(10000 / (i*i))


func get_random_name() -> String:
	var name : PoolByteArray
	var max_letters : int = randi() % 13 + 1
	for i in range(max_letters):
		name.append(65 + randi() % 26)

	return name.get_string_from_ascii()


func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://MainMenu.tscn")

