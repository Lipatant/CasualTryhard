extends Node
class_name SceneManager

# OTHER VARIABLES #

var current_scene : CanvasItem
#var player_manager : PlayerManager = PlayerManager.new()

# READY #

func _ready() -> void:
	load_scene()

# LOAD #

func load_scene(scene_data: SceneManagerData = SceneManagerData.new()) -> CanvasItem:
	if !scene_data:
		return null
	if current_scene:
		current_scene.queue_free()
	for child in get_children():
		child.queue_free()
	var resource : Resource = load(scene_data.resource_path)
	if !resource:
		return null
	current_scene = resource.instantiate()
	if current_scene:
		if "scene_manager" in current_scene:
			current_scene["scene_manager"] = self
		add_child(current_scene)
	return current_scene

# STATIC FUNCTIONS #

static func get_scene_manager(source: Node) -> SceneManager:
	if !source: return null
	var source_tree : SceneTree = source.get_tree()
	if !source_tree: return null
	return source_tree.current_scene

static func get_data(source: Node, data_name: String, default_value = null):
	if !source: return null
	var source_tree : SceneTree = source.get_tree()
	if !source_tree: return null
	var scene_manager : Node = source_tree.current_scene
	return scene_manager[data_name] if (scene_manager and (data_name in scene_manager)) else default_value

static func get_current_scene(source: Node) -> Node:
	if !source: return null
	var source_tree : SceneTree = source.get_tree()
	if !source_tree: return null
	var scene_manager : Node = source_tree.current_scene
	return scene_manager.current_scene if (scene_manager and ("current_scene" in scene_manager)) else scene_manager
