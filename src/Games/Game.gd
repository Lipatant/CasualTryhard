extends CanvasItem
class_name Game

# EXPORTS #

@export var rule : Rule = Rule.NONE
@export var win_on_end : bool = true

# ENUMS #

enum Rule {
	NONE,
	ALIGN,
	DODGE,
	HIT,
	LOSE,
	LOSE_OR_TIE,
	SCORE,
	STACK,
	SURVIVE,
	WIN,
	WIN_OR_TIE,
}

const RULE_TEXT : Dictionary = {
	Rule.NONE: "????",
	Rule.ALIGN: "Align!",
	Rule.DODGE: "Dodge!",
	Rule.HIT: "Hit!",
	Rule.LOSE: "Lose!",
	Rule.LOSE_OR_TIE: "Lose or Tie!",
	Rule.SCORE: "Score!",
	Rule.STACK: "Stack!",
	Rule.SURVIVE: "Survive!",
	Rule.WIN: "Win!",
	Rule.WIN_OR_TIE: "Win or Tie!",
}

enum State {
	PREPARE,
	PLAYING,
	ENDED,
}

# SIGNALS #

signal game_end

# OTHER VARIABLES #

var game_manager : GameManager
var game_state : State = State.PREPARE

# INPUTS #

func _input(event: InputEvent):
	if event is InputEventScreenTouch and event.is_pressed():
		_new_click_input(event.get_position())
	elif (event is InputEventMouseButton) and event.is_pressed():
		_new_click_input(event.get_position())

func _new_click_input(_position : Vector2) -> void:
	pass

# EVENTS #

func start() -> void:
	game_state = State.PLAYING

func end() -> bool:
	game_state = State.ENDED
	return win_on_end
