extends CanvasLayer


signal start_game


func show_message(text: String) -> void:
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
	
func show_game_over() -> void:
	show_message("Game Over")
	
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text = "Dodge The\nCreeps!"
	$MessageLabel.show()
	
	yield(get_tree().create_timer(1), "timeout")
	
	$StartButton.show()
	
	
func update_score(score: int) -> void:
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed() -> void:
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout() -> void:
	$MessageLabel.hide()

