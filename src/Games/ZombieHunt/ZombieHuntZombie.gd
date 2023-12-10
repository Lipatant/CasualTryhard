extends Area2D
class_name ZombieHuntZombie

@export var collision_shape : CollisionShape2D

var game : Game
var die : bool = false

func kill():
	queue_free()
	get_parent().remove_child(self)

func _process(_delta):
	position.y += 1
