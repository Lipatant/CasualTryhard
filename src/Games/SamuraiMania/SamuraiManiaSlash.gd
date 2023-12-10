extends Sprite2D
class_name SamuraiManiaSlash

# EXPORTS #

@export var timer_frame : Timer

var current_frame : int = randi() % vframes

# ANIMATION #

func _process(_delta: float) -> void:
	if timer_frame and !timer_frame.is_stopped() and timer_frame.wait_time > 0:
		modulate = Color.WHITE * (timer_frame.time_left / timer_frame.wait_time) * 0.8
	else:
		modulate = Color.TRANSPARENT

func animate(animation_frame: SamuraiManiaSamurai.Frame) -> void:
	frame_coords.x = animation_frame
	current_frame = (current_frame + 1) % vframes
	frame_coords.y = current_frame
	if timer_frame: timer_frame.start()

# SIGNALS #

func _on_timer_frame_timeout() -> void:
	frame_coords.x = SamuraiManiaSamurai.Frame.IDLE
