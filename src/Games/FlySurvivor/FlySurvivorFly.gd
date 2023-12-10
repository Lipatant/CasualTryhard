extends Area2D

class_name Fly

@onready var sprite = $Sprite2D

var dead = false

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if !dead:
		position = get_global_mouse_position()

func die():
	dead = true
	sprite.modulate = Color(0.9, 0.1, 0.1)
