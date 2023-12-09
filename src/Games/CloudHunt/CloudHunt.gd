extends Game

# EXPORT #

@export var cloud_container : Node

# ONREADIES #

@onready var cloud_resource : Resource = preload("res://src/Games/CloudHunt/CloudHuntCloud.tscn")

# OTHER VARIABLES #

var cloud_count : int = 0

# INPUTS #

func _ready() -> void:
	for child in (cloud_container.get_children() if cloud_container else get_children()):
		if child is CloudHuntCloud:
			cloud_count += 1

func _new_click_input(position : Vector2) -> void:
	if game_state != State.PLAYING or !cloud_container: return
	var cloud_hit : int = 0
	var cloud_rect : Rect2
	for cloud : CloudHuntCloud in cloud_container.get_children():
		if !cloud.collision_shape or !cloud.collision_shape.shape: continue
		cloud_rect = cloud.collision_shape.shape.get_rect()
		if !Rect2(cloud.collision_shape.global_position + cloud_rect.position, cloud_rect.size).has_point(position):
			continue
		cloud_count -= 1
		cloud_hit += 1
		cloud.queue_free()
		cloud_container.remove_child(cloud)
	if cloud_count < 1:
		game_end.emit(true)
	if cloud_hit < 1:
		game_end.emit(false)
