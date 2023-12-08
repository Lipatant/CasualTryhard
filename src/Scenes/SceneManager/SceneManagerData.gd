class_name SceneManagerData

# SCENE-RELATED CONSTANTS #

enum {
	SCENE_LEVEL,
	SCENE_MAIN_MENU,
	SCENE_TOTAL
}
const SCENE_DEFAULT : int = SCENE_MAIN_MENU
const SCENE_DEFAULT_DATA : Dictionary = {
	SCENE_MAIN_MENU: "res://Scenes/Scenes/MainMenu.tscn",
}

# OTHER VARIABLES #

var resource_path : String = ""

# CONSTRUCTOR #

func _init(scene_type: int = SCENE_DEFAULT) -> void:
	if SCENE_DEFAULT_DATA.has(scene_type):
		resource_path = SCENE_DEFAULT_DATA[scene_type]
