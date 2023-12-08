extends Control

# EXPORTS #

@export var default_focus : Control

# OTHER VARIABLES #

var scene_manager : SceneManager

# READY #

func _ready() -> void:
	if default_focus:
		default_focus.grab_focus()

# SIGNALS #

func _on_new_game_pressed() -> void:
	if scene_manager:
		scene_manager.load_scene()

func _on_exit_pressed() -> void:
	get_tree().quit()
