extends Node2D

@export var rotation_delta : float = 0.3

func _process(_delta: float) -> void:
	rotation = rotation + (rotation_delta * _delta)
