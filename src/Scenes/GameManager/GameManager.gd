extends Node
class_name GameManager

# EXPORT #

## Node to place game scenes in
## self by default
@export var game_container : Control
@export var timer : Timer
@export var timer_range : Range

# CONSTS #

const GAMES : Array[String] = [
	"CloudHunt"
]

# OTHER VARIABLES #

var current_game : Game

# READY #

func _ready() -> void:
	if timer:
		timer.timeout.connect(_on_timer_timeout)
	load_game()

# PROCESS #

func _process(_delta: float) -> void:
	if timer and timer_range:
		if timer.wait_time > 0:
			timer_range.value = timer.time_left / timer.wait_time

# SIGNALS #

func _on_timer_timeout() -> void:
	if timer: timer.start()

# LOAD #

func load_game(game_name: String = "") -> void:
	if !game_name:
		return load_game(GAMES[0])
	if current_game:
		current_game.queue_free()
	var resource : Resource = load("res://src/Games/" + game_name + ".tscn")
	if !resource:
		return
	current_game = resource.instantiate()
	if current_game:
		if "game_manager" in current_game:
			current_game["game_manager"] = self
		current_game.game_manager = self
		print(current_game)
		if game_container:
			game_container.add_child(current_game)
		else:
			add_child(current_game)
