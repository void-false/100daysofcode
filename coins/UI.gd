extends Control


onready var score_text = get_node("ScoreText")


func _ready() -> void:
	set_score_text(0)
	

func set_score_text(score: int) -> void:
	score_text.text = str(score)
