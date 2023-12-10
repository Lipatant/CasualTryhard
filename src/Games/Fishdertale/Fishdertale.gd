extends Game

# EXPORT #

@export var fish : FishdertaleFish
@export var rod_container : Node
@export var timer : Timer
@export var fishingRod: AudioStreamPlayer

# ONREADIES #

@onready var rod_resource : Resource = preload("res://src/Games/Fishdertale/FishdertaleRod.tscn")

# INPUT #

func start() -> void:
	super.start()
	if fish and fish.collision_shape: fish.collision_shape.disabled = false
	if timer: timer.start()
	_spawn_rod()

func end() -> bool:
	if fish:
		if fish.collision_shape: fish.collision_shape.disabled = true
		fish.target = fish.global_position
	return super.end()

func _new_click_input(click_position : Vector2) -> void:
	if game_state != State.PLAYING: return
	if fish: fish.target = click_position

# INPUT #

func _spawn_rod() -> void:
	if fishingRod: fishingRod.play()
	if !rod_resource or !rod_container or rod_container.get_child_count() < 1 or !fish : return
	var rod_container_point : Node2D = rod_container.get_children()[(game_manager.rng.randi() if (game_manager and game_manager.rng) else 0) % rod_container.get_child_count()]
	if !rod_container_point: return
	var rod : FishdertaleRod = rod_resource.instantiate()
	if !rod: return
	rod.fixed_rotation = (fish.global_position - rod_container_point.global_position).angle()
	rod_container_point.add_child(rod)

# SIGNALS #

func _on_fish_area_entered(_area: Area2D):
	game_end.emit(false)

func _on_timer_timeout():
	_spawn_rod()
