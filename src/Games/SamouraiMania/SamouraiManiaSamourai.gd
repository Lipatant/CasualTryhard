extends Area2D
class_name SamouraiManiaSamourai

# EXPORTS #

@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D
@export var timer_frame : Timer

# CONST #

enum Frame {
	IDLE = 0,
	UP = 1,
	DOWN = 2,
}

# ANIMATION #

func animate(frame : Frame) -> void:
	if sprite: sprite.frame = frame
	if timer_frame: timer_frame.start()

# SIGNALS #

func _on_timer_frame_timeout() -> void:
	if sprite: sprite.frame = Frame.IDLE
