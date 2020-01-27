extends MarginContainer


func _ready() -> void:
	# Globals.score += 10000 / ((Globals.end_time - Globals.start_time) / 1000)
	$"VBoxContainer/HBoxContainer/PointsLabel".text = String(Globals.score)
	$"VBoxContainer/NameLineEdit".grab_focus()


func _on_NameLineEdit_text_changed(new_text):
	$"VBoxContainer/NameLineEdit".text = $VBoxContainer/NameLineEdit.text.to_upper()
	$"VBoxContainer/NameLineEdit".caret_position = 20


func _on_SubmitButton_pressed():
	Globals.update_score($"VBoxContainer/NameLineEdit".text)
	get_tree().change_scene("res://HighScore.tscn")
