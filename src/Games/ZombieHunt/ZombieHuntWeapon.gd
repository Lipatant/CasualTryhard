extends Area2D

class_name ZombieHuntWeapon

@onready var timer = $Timer
@onready var sprite = $Sprite2D

var idle = preload("res://graphic/ZombieHunt/weapon1.png"); 
var fire = preload("res://graphic/ZombieHunt/weapon2.png");

func _process(_delta):
	position.x = get_global_mouse_position().x

func shoot():
	sprite.set_texture(fire)
	timer.start()

func _on_timer_timeout():
	sprite.set_texture(idle)
