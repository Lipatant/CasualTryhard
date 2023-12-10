extends Area2D

class_name FlySurvivorFly

@onready var sprite = $Sprite2D

var dead = false

func _process(_delta):
	if !dead:
		position = get_global_mouse_position()

func die():
	dead = true
	if sprite:
		sprite.frame = 1
		sprite.modulate = Color.DIM_GRAY
