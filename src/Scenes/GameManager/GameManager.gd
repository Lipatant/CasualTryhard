extends Node
class_name GameManager

# EXPORT #

## Node to place game scenes in
## self by default
@export var game_container : Control
@export var timer : Timer
@export var timer_transition : Timer
@export var timer_range : Range
@export var health_label : Label
@export var name_label : Label
@export var name_label_old : Label
@export var rule_label : Label

# CONSTS #

const GAMES : Array[String] = [
	"CloudHunt",
	"TicTacToe",
	"Fishdertale",
	"RythmHero",
	"SakuraNeko",
]

# OTHER VARIABLES #

var current_game : Game
var current_game_id : int = 0
var health : int = 3
var previous_game : Game
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var scene_manager : SceneManager
var current_game_list : Array[String] = GAMES.duplicate()
var next_game_list : Array[String] = []

# READY #

func _ready() -> void:
	if timer:
		timer.timeout.connect(_on_timer_timeout)
	if timer_transition:
		timer_transition.timeout.connect(_on_timer_transition_timeout)
	if scene_manager: scene_manager.score = 0
	_set_health(health)
	if timer_transition: timer_transition.start()
	load_game()

# PROCESS #

func _process(_delta: float) -> void:
	if timer_range:
		if timer and timer.wait_time > 0 and !timer.is_stopped():
			timer_range.value = timer.time_left / timer.wait_time
		elif timer_transition and timer_transition.wait_time > 0:
			timer_range.value = 1.0 - timer_transition.time_left / timer_transition.wait_time
	if timer and timer.is_stopped() and !timer_transition.is_stopped() and timer_transition.wait_time > 0:
		if current_game:
			current_game.modulate = Color.WHITE * (1.0 - timer_transition.time_left / timer_transition.wait_time)
		if name_label:
			name_label.modulate = Color.WHITE * (1.0 - timer_transition.time_left / timer_transition.wait_time)
		if previous_game:
			previous_game.modulate = Color.WHITE * timer_transition.time_left / timer_transition.wait_time
		if name_label_old:
			name_label_old.modulate = Color.WHITE * timer_transition.time_left / timer_transition.wait_time

# HEALTHS #

func _set_health(new_health: int) -> void:
	if new_health < 0:
		health = 0
	else:
		health = new_health
	if health_label:
		health_label.text = " "
		for _i in range(health):
			health_label.text += "♥"

func _get_health() -> int:
	return health;

# SIGNALS #

func _on_timer_timeout() -> void:
	call_deferred("_current_game_end", true)

func _current_game_end(use_end_output: bool = true, win: bool = false) -> void:
	if timer_transition: timer_transition.start()
	if rule_label: rule_label.visible = true
	var has_won : bool = win
	if current_game:
		if use_end_output:
			has_won = current_game.end()
		else:
			current_game.end()
	if has_won:
		if scene_manager: scene_manager.score += 1
	else:
		_set_health(health - 1)
		if health < 1:
			load_game("", true)
			return
	load_game()

func _on_timer_transition_timeout() -> void:
	if timer: timer.start()
	if rule_label: rule_label.visible = false
	if previous_game:
		previous_game.queue_free()
		previous_game = null
	if current_game:
		current_game.start()
		current_game.modulate = Color.WHITE
	if !current_game and scene_manager:
		scene_manager.load_scene(SceneManagerData.new(SceneManagerData.SCENE_END_OF_GAME))

## When the game end BEFORE the timer
func _on_game_end(_win: bool) -> void:
	timer.stop()
	call_deferred("_current_game_end", false, _win)

# LOAD #

func get_random_game() -> String:
	if (current_game_list.size() == 0):
		current_game_list = next_game_list
		next_game_list = []
	var rand: int = randi_range(0, current_game_list.size() - 1)
	var game: String = current_game_list[rand]
	current_game_list.remove_at(rand)
	next_game_list.push_back(game)
	return game

func load_game(game_name: String = "", force_null: bool = false) -> void:
	if force_null:
		if previous_game: previous_game.queue_free()
		if name_label_old: name_label_old.text = name_label.text
		if name_label: name_label.text = ""
		if rule_label: rule_label.text = ""
		previous_game = current_game
		current_game = null
		return
	if !game_name:
		var new_game = get_random_game()
		return load_game(new_game, force_null)
	var resource : Resource = load("res://src/Games/" + game_name + ".tscn")
	if scene_manager:
		scene_manager.last_game = game_name
	if name_label_old: name_label_old.text = name_label.text
	if name_label: name_label.text = game_name + " "
	if !resource:
		return
	if previous_game:
		previous_game.queue_free()
	previous_game = current_game
	current_game = resource.instantiate()
	if current_game:
		if rule_label:
			rule_label.text = Game.RULE_TEXT[current_game.rule] if Game.RULE_TEXT.has(current_game.rule) else ""
		current_game.game_manager = self
		current_game.modulate = Color.WHITE * 1.0
		current_game.game_end.connect(_on_game_end)
		if game_container:
			game_container.add_child(current_game)
		else:
			add_child(current_game)
