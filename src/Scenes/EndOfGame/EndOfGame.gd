extends Control

# EXPORTS #

@export var default_focus : Control
@export var timer : Timer
@export var score_label : Label
@export var game_label : Label

# OTHER VARIABLES #

var scene_manager : SceneManager

# READY #

func _ready() -> void:
	if default_focus:
		default_focus.grab_focus()
	if scene_manager:
		if score_label: score_label.text += str(scene_manager.score)
	if game_label:
		if scene_manager:
			game_label.text += scene_manager.last_game
		else:
			game_label.text = ""
	_process(0.0)

# PROCESS #

func _process(_delta: float) -> void:
	if timer and !timer.is_stopped() and timer.wait_time:
		modulate = Color.WHITE * (1.0 - timer.time_left / timer.wait_time)
	else:
		modulate = Color.WHITE

# SIGNALS #

func _on_play_pressed() -> void:
	if scene_manager:
		scene_manager.load_scene(SceneManagerData.new(SceneManagerData.SCENE_GAME))

func _on_exit_pressed() -> void:
		scene_manager.load_scene(SceneManagerData.new(SceneManagerData.SCENE_MAIN_MENU))
