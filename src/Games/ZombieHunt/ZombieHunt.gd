extends Game

# EXPORT #

@export var zombie_container : Node

# ONREADIES #

@onready var zombie_resource : Resource = preload("res://src/Games/ZombieHunt/ZombieHuntZombie.tscn")

# OTHER VARIABLES #

var zombie_count : int = 0

# INPUTS #

func _ready() -> void:
	for child in (zombie_container.get_children() if zombie_container else get_children()):
		if child is ZombieHuntZombie:
			zombie_count += 1

func _new_click_input(position : Vector2) -> void:
	if game_state != State.PLAYING or !zombie_container: return
	var zombie_hit : int = 0
	var zombie_rect : Rect2
	for zombie : ZombieHuntZombie in zombie_container.get_children():
		if !zombie.collision_shape or !zombie.collision_shape.shape: continue
		zombie_rect = zombie.collision_shape.shape.get_rect()
		if !Rect2(zombie.collision_shape.global_position + zombie_rect.position, zombie_rect.size).has_point(position):
			continue
		zombie_count -= 1
		zombie_hit += 1
		zombie.queue_free()
		zombie_container.remove_child(zombie)
	if zombie_count < 1:
		game_end.emit(true)
	if zombie_hit < 1:
		game_end.emit(false)
