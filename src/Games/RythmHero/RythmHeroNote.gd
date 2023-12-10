extends Area2D
class_name RythmHeroNote

@export var sprite : Sprite2D
@export var timer : Timer
@export var timer_overtime : Timer

var game : Game
var target_position : Vector2

func _ready() -> void:
	if sprite: sprite.frame = randi() % (sprite.vframes * sprite.hframes)

func _physics_process(_delta: float) -> void:
	if timer and timer.wait_time > 0 and !timer.is_stopped():
		position = target_position * (1.0 - timer.time_left / timer.wait_time)
	else:
		position = target_position

func _on_timer_timeout():
	if timer_overtime: timer_overtime.start()

func _on_timer_overtime_timeout():
	if game and game.game_state == Game.State.PLAYING:
		game.game_end.emit(false)
		queue_free()
