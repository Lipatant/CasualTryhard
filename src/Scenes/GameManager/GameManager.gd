extends Node
class_name GameManager

# EXPORT #

## Node to place level scenes in
## self by default
@export var level_container : Node

# CONSTS #



# OTHER VARIABLES #

var current_game : CanvasItem

# READY #

func _ready() -> void:
	load_scene()

# LOAD #

func load_scene(scene_data: SceneManagerData = SceneManagerData.new()) -> CanvasItem:
	if !scene_data:
		return null
	if current_game:
		current_game.queue_free()
	for child in get_children():
		child.queue_free()
	var resource : Resource = load(scene_data.resource_path)
	if !resource:
		return null
	current_game = resource.instantiate()
	if current_game:
		if "game_manager" in current_game:
			current_game["game_manager"] = self
		add_child(current_game)
	return current_game
