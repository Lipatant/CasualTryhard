extends Game

# EXPORTS #

@export var border_collision_shape : CollisionShape2D
@export var cat : SakuraNekoCat
@export var cat_movement_container : Node2D
@export var cat_sound : AudioStreamPlayer
@export var petal_container : Node2D
@export var timer : Timer
@export var timer_cat : Timer
@export var umbrella : SakuraNekoUmbrella

# ONREADIES #

@onready var petal_resource : Resource = preload("res://src/Games/SakuraNeko/SakuraNekoPetal.tscn")

# START #

func _ready() -> void:
	_on_timer_cat_timeout()

func start() -> void:
	super.start()
	if cat and cat.collision_shape: cat.collision_shape.disabled = false
	if umbrella and umbrella.collision_shape: umbrella.collision_shape.disabled = false
	if timer: timer.start()
	_on_timer_timeout()

func end() -> bool:
	if cat and cat.collision_shape: cat.collision_shape.disabled = true
	if umbrella and umbrella.collision_shape: umbrella.collision_shape.disabled = true
	return super.end()

#

func _new_click_input(click_position : Vector2) -> void:
	if game_state != State.PLAYING: return
	if umbrella: umbrella.target = click_position

# INPUT #

func _spawn_petal() -> void:
	if !petal_resource or !petal_container or petal_container.get_child_count() < 1 : return
	var petal_container_point : Node2D = petal_container.get_children()[randi() % petal_container.get_child_count()]
	if !petal_container_point: return
	var petal : SakuraNekoPetal = petal_resource.instantiate()
	if !petal: return
	petal.game = self
	petal.cat_hit.connect(_on_petal_cat_hit)
	petal_container_point.add_child(petal)

func _on_petal_cat_hit() -> void:
	if game_state != State.PLAYING: return
	if cat:
		cat.queue_free()
		cat = null
	if cat_sound: cat_sound.play()
	game_end.emit(false)

# SIGNALS #

func _on_timer_timeout():
	_spawn_petal()

func _on_timer_cat_timeout():
	if !cat or !cat_movement_container or cat_movement_container.get_child_count() < 1: return
	cat.target = cat_movement_container.get_child(randi() % cat_movement_container.get_child_count()).global_position
