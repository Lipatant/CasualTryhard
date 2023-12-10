extends Area2D
class_name CloudHuntCloud

@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D

var game : Game

func _ready() -> void:
	if sprite: sprite.frame = randi() % (sprite.vframes * sprite.hframes)
