extends Area2D
class_name ZombieHuntZombie

@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D

var game : Game
var die : bool = false

func _ready() -> void:
	if sprite: sprite.frame = randi() % (sprite.hframes * sprite.vframes)

func kill():
	queue_free()
	get_parent().remove_child(self)

func _process(_delta):
	position.y += 1
