extends Game

# EXPORT #

@export var cloud_container : Node
@export var cloud_count : int = 6

# INPUTS #

func _ready() -> void:
	var child_count : int = cloud_container.get_child_count()
	var child : Node = null
	if cloud_container:
		while child_count > cloud_count:
			child = cloud_container.get_child(randi() % (cloud_container.get_child_count()))
			cloud_container.remove_child(child)
			child.queue_free()
			child_count -= 1
	if child_count < cloud_count:
		cloud_count = child_count

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
