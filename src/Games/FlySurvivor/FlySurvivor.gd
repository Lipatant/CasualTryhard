extends Game

# EXPORT #

@export var fly : FlySurvivorFly
@export var slap : FlySurvivorSlap

# OTHER VARIABLES #

func end() -> bool:
	if !slap or !fly: return super.end()
	slap.slapNow()
	if slap.didHit(fly.position):
		fly.die()
		return false
	return true
