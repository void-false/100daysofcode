extends Node


export (PackedScene) var Mob
var score: int


func _ready() -> void:
	randomize()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	
func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_StartTimer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout() -> void:
	score += 1


func _on_MobTimer_timeout() -> void:
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob: Node = Mob.instance()
	add_child(mob)
	var direction: float = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
