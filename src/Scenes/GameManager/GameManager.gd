extends Control
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
@export var rule_event_label : Label
@export var rule_event_info_label : Label
@export var loose_life_sound : AudioStreamPlayer

# CONSTS #

const GAMES : Array[String] = [
	"CloudHunt",
	"TicTacToe",
	"ZombieHunt",
	"Fishdertale",
	"RythmHero",
	"SakuraNeko",
	"FlySurvivor",
	"SamuraiMania",
]

# ENUM #

enum Event {
	NONE,
	LOSE,
	FAST,
	REALLYFAST,
}

const EVENT_TEXT : Dictionary = {
	Event.LOSE: "DO NOT",
}

const EVENT_TEXT_INFO : Dictionary = {
	Event.FAST: "Faster",
	Event.REALLYFAST: "REALLY FAST!",
}

const EVENT_EXCLUDE : Dictionary = {
	Event.LOSE: ["TicTacToe", "SakuraNeko"],
	Event.FAST: ["RythmHero", "Fishdertale", "SakuraNeko"],
	Event.REALLYFAST: ["RythmHero", "Fishdertale", "SakuraNeko", "CloudHunt", "ZombieHunt"],
}

# OTHER VARIABLES #

var current_game : Game
var current_game_id : int = 0
var health : int = 3
var previous_game : Game
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var scene_manager : SceneManager
var current_game_list : Array[String] = GAMES.duplicate()
var next_game_list : Array[String] = []

var _events : Array[Event]
var _timer_default : float
var _current_transition : Vector2
var _current_transition_rotation : float = 0.0

# READY #

func _ready() -> void:
	if timer:
		timer.timeout.connect(_on_timer_timeout)
		_timer_default = timer.wait_time
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
			current_game.position = _current_transition * timer_transition.time_left / timer_transition.wait_time
			current_game.rotation = _current_transition_rotation * timer_transition.time_left / timer_transition.wait_time
		if previous_game:
			previous_game.modulate = Color.WHITE * timer_transition.time_left / timer_transition.wait_time
			previous_game.position = _current_transition * (1.0 - timer_transition.time_left / timer_transition.wait_time)
			previous_game.rotation = _current_transition_rotation * (1.0 - timer_transition.time_left / timer_transition.wait_time)
		if name_label_old:
			name_label_old.modulate = Color.WHITE * timer_transition.time_left / timer_transition.wait_time
		if name_label:
			name_label.modulate = Color.WHITE * (1.0 - timer_transition.time_left / timer_transition.wait_time)

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

func _get_new_transition() -> void:
	var transitions : Array[Vector2] = [
		Vector2(0, 0), Vector2(0, 0),
		Vector2(0, 0), Vector2(0, 0),
		Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)
	]
	var transition_rotations : Array[float] = [
		0.0, 0.0,
		-1.0, 1.0,
		0.0, 0.0, 0.0, 0.0,
	]
	var transitionID : int = randi() % min(transitions.size(), transition_rotations.size())
	_current_transition = transitions[transitionID] * size
	_current_transition_rotation = transition_rotations[transitionID] * PI

func _current_game_end(use_end_output: bool = true, win: bool = false) -> void:
	_get_new_transition()
	if timer_transition: timer_transition.start()
	if rule_label: rule_label.visible = true
	if rule_event_label: rule_event_label.visible = true
	if rule_event_info_label: rule_event_info_label.visible = true
	var has_won : bool = win
	if current_game:
		if use_end_output:
			has_won = current_game.end()
		else:
			current_game.end()
	if _events.has(Event.LOSE): has_won = !has_won
	if has_won:
		if scene_manager: scene_manager.score += 1
	else:
		_set_health(health - 1)
		if loose_life_sound: loose_life_sound.play()
		if health < 1:
			load_game("", true)
			return
	load_game()

func _on_timer_transition_timeout() -> void:
	if timer: timer.start()
	if rule_label: rule_label.visible = false
	if rule_event_label: rule_event_label.visible = false
	if rule_event_info_label: rule_event_info_label.visible = false
	if previous_game:
		previous_game.queue_free()
		previous_game = null
	if current_game:
		current_game.modulate = Color.WHITE
		current_game.position = Vector2(0.0, 0.0)
		current_game.rotation = 0
		current_game.start()
	if !current_game and scene_manager:
		scene_manager.load_scene(SceneManagerData.new(SceneManagerData.SCENE_END_OF_GAME))

## When the game end BEFORE the timer
func _on_game_end(_win: bool) -> void:
	timer.stop()
	if current_game: current_game.game_end.disconnect(_on_game_end)
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
		if rule_event_label: rule_event_label.text = ""
		if rule_event_info_label: rule_event_info_label.text = ""
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
		#
		_events.clear()
		if rule_event_label: rule_event_label.text = ""
		if rule_event_info_label: rule_event_info_label.text = ""
		if !(EVENT_EXCLUDE.get(Event.LOSE, []).has(game_name)) and (randi() % 5 < 1):
			_events.append(Event.LOSE)
			if rule_event_label and EVENT_TEXT.has(Event.LOSE): rule_event_label.text = EVENT_TEXT.get(Event.LOSE)
			if rule_event_info_label and EVENT_TEXT_INFO.has(Event.LOSE): rule_event_info_label.text = EVENT_TEXT_INFO.get(Event.LOSE)
		if !(EVENT_EXCLUDE.get(Event.FAST, []).has(game_name)) and (randi() % 5 < 1):
			_events.append(Event.FAST)
			if rule_event_label and EVENT_TEXT.has(Event.FAST): rule_event_label.text = EVENT_TEXT.get(Event.FAST)
			if rule_event_info_label and EVENT_TEXT_INFO.has(Event.FAST): rule_event_info_label.text = EVENT_TEXT_INFO.get(Event.FAST)
		elif !(EVENT_EXCLUDE.get(Event.REALLYFAST, []).has(game_name)) and (randi() % 5 < 1):
			_events.append(Event.REALLYFAST)
			if rule_event_label and EVENT_TEXT.has(Event.REALLYFAST): rule_event_label.text = EVENT_TEXT.get(Event.REALLYFAST)
			if rule_event_info_label and EVENT_TEXT_INFO.has(Event.REALLYFAST): rule_event_info_label.text = EVENT_TEXT_INFO.get(Event.REALLYFAST)
		#
		current_game.game_manager = self
		current_game.modulate = Color.WHITE * 1.0
		current_game.game_end.connect(_on_game_end)
		if _events.has(Event.FAST):
			current_game.game_time_multiplier *= 0.75
		if _events.has(Event.REALLYFAST):
			current_game.game_time_multiplier *= 0.5
		if game_container:
			game_container.add_child(current_game)
		else:
			add_child(current_game)
		if timer: timer.wait_time = _timer_default * current_game.game_time_multiplier
