extends Node
class_name Game

# EXPORTS #

@export var rule : Rule = Rule.NONE

# ENUMS #

enum Rule {
	NONE,
	ALIGN,
	DODGE,
	HIT,
	SCORE,
	STACK,
	SURVIVE,
}

# SIGNALS #

signal game_end

# OTHER VARIABLES #

var game_manager : GameManager

# EVENTS

func start() -> void:
	pass

func end() -> bool:
	return true
