extends Game

# EXPORT #

@export var fly : Fly
@export var slap : Slap

# ONREADIES #

@onready var timer = $Timer

# OTHER VARIABLES #

func _on_timer_timeout():
	print("timer timeout")
	if !slap or !fly: return
	print("slap and fly ok")
	slap.slapNow()
	print("slaped")
	if slap.didHit(fly.position):
		print("slaped hit")
		fly.die()
		game_end.emit(false)
	print("end")
