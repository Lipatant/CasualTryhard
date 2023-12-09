extends Area2D
class_name FishdertaleFish

# EXPORT #

@export var speed : float = 1000.0
@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D

# OTHER VARIABLES #

var target : Vector2

# READY #

func _ready() -> void:
	target = global_position

# PROCESS #

func _physics_process(delta: float) -> void:
	if global_position == target:
		return
	var difference : Vector2 = target - global_position
	var velocity : Vector2 = Vector2(0, 0)
	var length : float = difference.length()
	if length < speed * delta:
		velocity = difference
	else:
		velocity = difference.normalized() * speed * delta
	position += velocity


func _on_timer_timeout():
	pass # Replace with function body.
