extends Area2D
class_name TicTacToePiece

# EXPORTS #

@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D

# ENUMS #

enum Value {
	NONE,
	CIRCLE,
	CROSS,
}

# OTHER VARIABLES #

var _value : Value = Value.NONE

# READY #

func _ready() -> void:
	set_value()

# VALUE #

func set_value(new_value : Value = Value.NONE) -> void:
	_value = new_value
	sprite.frame_coords.y = new_value

func get_value() -> Value:
	return _value

func is_empty() -> bool:
	return (get_value() == Value.NONE)
