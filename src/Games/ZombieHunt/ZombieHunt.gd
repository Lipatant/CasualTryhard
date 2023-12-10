extends Game

# EXPORT #

@export var zombie_container : Node
@export var weapon : ZombieHuntWeapon
@export var gunshot: AudioStreamPlayer
# ONREADIES #

@onready var zombie_resource : Resource = preload("res://src/Games/ZombieHunt/ZombieHuntZombie.tscn")
# OTHER VARIABLES #

var zombie_count : int = 0

# INPUTS #

func _ready() -> void:
	for child in (zombie_container.get_children() if zombie_container else get_children()):
		if child is ZombieHuntZombie:
			zombie_count += 1

func _process(_delta):
	if !zombie_container: return

func _new_click_input(position : Vector2) -> void:
	if gunshot: gunshot.play()
	if game_state != State.PLAYING or !zombie_container or !weapon: return
	weapon.shoot()
	var zombie_rect : Rect2
	for zombie : ZombieHuntZombie in zombie_container.get_children():
		if !zombie.collision_shape or !zombie.collision_shape.shape: continue
		zombie_rect = zombie.collision_shape.shape.get_rect()
		if position.x >= zombie.collision_shape.global_position.x - zombie_rect.size.x / 2 and position.x <= zombie.collision_shape.global_position.x + zombie_rect.size.x / 2:
			zombie_count -= 1
			zombie.kill()
			continue
	if zombie_count < 1:
		game_end.emit(true)
