extends Node
class_name GameManager

# EXPORT #

## Node to place game scenes in
## self by default
@export var game_container : Control
@export var timer : Timer
@export var timer_transition : Timer
@export var timer_range : Range

# CONSTS #

const GAMES : Array[String] = [
	"CloudHunt",
	"TicTacToe",
]

# OTHER VARIABLES #

var current_game : Game
var current_game_id : int = 0
var previous_game : Game
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# READY #

func _ready() -> void:
	if timer:
		timer.timeout.connect(_on_timer_timeout)
	if timer_transition:
		timer_transition.timeout.connect(_on_timer_transition_timeout)
	_on_timer_timeout()

# PROCESS #

func _process(_delta: float) -> void:
	if timer_range:
		if timer and timer.wait_time > 0 and !timer.is_stopped():
			timer_range.value = timer.time_left / timer.wait_time
		elif timer_transition and timer_transition.wait_time > 0:
			timer_range.value = 1.0 - timer_transition.time_left / timer_transition.wait_time
	if timer.is_stopped() and !timer_transition.is_stopped() and timer_transition.wait_time > 0:
		if current_game:
			current_game.modulate = Color.WHITE * (1.0 - timer_transition.time_left / timer_transition.wait_time)
		if previous_game:
			previous_game.modulate = Color.WHITE * timer_transition.time_left / timer_transition.wait_time

# SIGNALS #

func _on_timer_timeout() -> void:
	if timer_transition: timer_transition.start()
	if current_game: current_game.end()
	load_game()

func _on_timer_transition_timeout() -> void:
	if timer: timer.start()
	if current_game:
		current_game.start()
		current_game.modulate = Color.WHITE
	if previous_game:
		previous_game.queue_free()
		previous_game = null

## When the game end BEFORE the timer
func _on_game_end(_win: bool) -> void:
	timer.stop()
	_on_timer_timeout()

# LOAD #

func load_game(game_name: String = "") -> void:
	if !game_name:
		current_game_id = (current_game_id + 1) % GAMES.size()
		return load_game(GAMES[current_game_id])
	var resource : Resource = load("res://src/Games/" + game_name + ".tscn")
	if !resource:
		return
	if previous_game:
		previous_game.queue_free()
	previous_game = current_game
	current_game = resource.instantiate()
	if current_game:
		current_game.game_manager = self
		current_game.modulate = Color.WHITE * 1.0
		current_game.game_end.connect(_on_game_end)
		if game_container:
			game_container.add_child(current_game)
		else:
			add_child(current_game)
