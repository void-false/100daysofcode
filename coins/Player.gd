extends KinematicBody2D

onready var sprite = $Sprite
onready var ui = get_node("/root/MainScene/CanvasLayer/UI")

var score: int = 0
var speed: int = 400
var jumpForce: int = 400
var gravity: int = 800
var vel: Vector2 = Vector2()
var grounded: bool = false


func _physics_process(delta: float) -> void:
	vel.x = 0
	
	if Input.is_action_pressed("move_left"):
		vel.x -= speed
	if Input.is_action_pressed("move_right"):
		vel.x += speed
		
	vel = move_and_slide(vel, Vector2.UP)
	
	vel.y += gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y -= jumpForce
		
	if vel.x < 0:
		sprite.flip_h = true
	elif vel.x > 0:
		sprite.flip_h = false


func die() -> void:
	get_tree().reload_current_scene()


func collect_coin(value: int) -> void:
	score += value
	ui.set_score_text(score)
