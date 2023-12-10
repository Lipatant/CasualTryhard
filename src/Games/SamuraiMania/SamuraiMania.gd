extends Game

# EXPORTS #

@export var samurai : SamuraiManiaSamurai
@export var samurai_slash : SamuraiManiaSlash
@export var enemy_container : Node2D
@export var enemy_steps : int = 6
@export var enemy_position_start : Node2D
@export var enemy_position_end : Node2D
@export var timer : Timer

# ONREADY #

@onready var enemy_resource : Resource = preload("res://src/Games/SamuraiMania/SamuraiManiaEnemy.tscn")

# OTHER VARIABLES #

var enemy_list : Array[SamuraiManiaEnemy]
var enemy_movement : Vector2
var enemy_movement_end : Vector2
var enemy_countdown : int = 1
var player_locked : bool = false

# START #

func _ready() -> void:
	if timer: timer.start()
	for _i in range(enemy_steps):
		enemy_list.append(null)
	if enemy_position_start and enemy_position_end:
		enemy_movement = enemy_position_end.global_position - enemy_position_start.global_position
	if enemy_position_start and samurai:
		enemy_movement_end = samurai.global_position - enemy_position_start.global_position

func start() -> void:
	super.start()
	_on_timer_timeout()

func _new_click_input(position : Vector2) -> void:
	if game_state != State.PLAYING: return
	if !samurai or player_locked: return
	var frame : SamuraiManiaSamurai.Frame = SamuraiManiaSamurai.Frame.IDLE
	if position.y < samurai.global_position.y:
		frame = SamuraiManiaSamurai.Frame.UP
	else:
		frame = SamuraiManiaSamurai.Frame.DOWN
	samurai.animate(frame)
	player_locked = true
	if samurai_slash: samurai_slash.animate(frame)
	if enemy_list.front():
		if enemy_list.front().type == frame:
			enemy_list[0].queue_free()
			enemy_list[0] = null
		else:
			_on_timer_timeout()

# TIMER #

func _on_timer_timeout():
	if game_state != State.PLAYING: return
	if enemy_list.front():
		player_locked = true
		if samurai:
			samurai.visible = false
			enemy_list.front().set_target(enemy_movement_end)
		if timer: timer.stop()
		game_end.emit(false)
		return
	enemy_list.pop_front()
	enemy_countdown -= 1
	player_locked = false
	if enemy_countdown < 1:
		enemy_list.append(_spawn_enemy())
		enemy_countdown = (randi() % 2) + 1
	else:
		enemy_list.append(null)
	var enemy_step : int = 0
	for enemy : SamuraiManiaEnemy in enemy_list:
		if enemy:
			enemy.set_target(enemy_movement * (1.0 - float(enemy_step) / float(enemy_steps - 1)))
		enemy_step += 1

func _spawn_enemy() -> SamuraiManiaEnemy:
	if !enemy_resource or !enemy_container: return null
	var enemy : SamuraiManiaEnemy = enemy_resource.instantiate()
	if !enemy: return null
	enemy.type = SamuraiManiaSamurai.Frame.UP if (randi() % 2) else SamuraiManiaSamurai.Frame.DOWN
	enemy_container.add_child(enemy)
	return enemy
