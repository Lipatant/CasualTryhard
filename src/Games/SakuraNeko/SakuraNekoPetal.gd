extends Area2D
class_name SakuraNekoPetal

@export var speed : float = 1000.0
@export var sprite : Sprite2D

var game : Game

signal cat_hit

func _ready() -> void:
	if sprite:
		sprite.frame = randi() % (sprite.hframes * sprite.vframes)

func _physics_process(_delta: float) -> void:
	position.x -= speed * _delta

func _on_area_entered(area: Area2D):
	if !game or game.game_state != Game.State.PLAYING: return
	if area is SakuraNekoCat:
		cat_hit.emit()
	queue_free()

func _on_timer_timeout():
	queue_free()
