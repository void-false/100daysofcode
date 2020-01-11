extends Node

class MyCustomSorter:
	static func sort(a, b):
		return a[0] > b[0]


var score : int = 0
var start_time : int = 0
var end_time : int = 1000
var high_score : Array

func _ready() -> void:
	high_score = generate_high_score()


func update_score(name : String) -> void:
	high_score.append([score, name])
	high_score.sort_custom(MyCustomSorter, "sort")
	high_score.resize(10)


func generate_high_score() -> Array:
	var table : Array = []
	randomize()
	for i in range(10):
		var row : Array = [0, "A"]
		row[0] = randi() % 500 + 1
		row[1] = get_random_name()
		table.append(row) 
	table.sort_custom(MyCustomSorter, "sort")

	return table


func get_random_name() -> String:
	var name : PoolByteArray
	var max_letters : int = randi() % 13 + 1
	for i in range(max_letters):
		name.append(65 + randi() % 26)

	return name.get_string_from_ascii()