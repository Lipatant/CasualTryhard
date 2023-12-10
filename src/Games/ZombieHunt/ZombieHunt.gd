extends Game

# EXPORT #

@export var zombie_container : Node
@export var weapon : ZombieHuntWeapon
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
	for zombie : ZombieHuntZombie in zombie_container.get_children():
		if zombie.position.y > 500:
			game_end.emit(false)

func _new_click_input(position : Vector2) -> void:
	if game_state != State.PLAYING or !zombie_container or !weapon: return
	weapon.shoot()
	var zombie_hit : int = 0
	var zombie_rect : Rect2
	for zombie : ZombieHuntZombie in zombie_container.get_children():
		if !zombie.collision_shape or !zombie.collision_shape.shape: continue
		zombie_rect = zombie.collision_shape.shape.get_rect()
		print("-----------------")
		print("zombie size : ", zombie_rect.size.x)
		print("zombie position : ", zombie.collision_shape.global_position.x)
		print("clic position : ", position.x)
		if position.x >= zombie.collision_shape.global_position.x - zombie_rect.size.x / 2 and position.x <= zombie.collision_shape.global_position.x + zombie_rect.size.x / 2:
			zombie_count -= 1
			zombie_hit += 1
			zombie.kill()
			continue
	if zombie_count < 1:
		game_end.emit(true)
