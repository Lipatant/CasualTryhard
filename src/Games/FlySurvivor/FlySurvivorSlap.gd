extends CharacterBody2D

class_name Slap

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var shape : CollisionShape2D = $CollisionShape2D

var target = Vector2(0, 0)
var precision = 200
var speed = 200
var slap = false

func _ready():
	sprite.modulate = Color(0.2,0.2,0.2)
	velocity = target

func _process(_delta):
	if !slap:
		move()

func _on_timer_timeout():
	target = getNewTarget(precision)
	if precision > 20:
		precision -= 20
	speed += 100

func move() -> void:
	var current_pos = self.position
	var direction = (target - current_pos).normalized()
	velocity = direction * speed
	if !position == target:
		target = getNewTarget(precision)
	move_and_slide()


func getNewTarget(radius: float) -> Vector2:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var random_angle = random.randf_range(0, 2 * PI)
	var random_radius = random.randf_range(0, radius)

	var x = cos(random_angle) * random_radius
	var y = sin(random_angle) * random_radius

	var mouse_position = get_global_mouse_position()
	var approximate_position = mouse_position + Vector2(x, y)
	approximate_position.y += 150

	return approximate_position

func didHit(point: Vector2) -> bool:
	var slap_rect = shape.shape.get_rect()
	print("did hit ?")
	return Rect2(shape.global_position + slap_rect.position, slap_rect.size).has_point(point)

func slapNow():
	slap = true
	sprite.modulate = Color(1.0,1.0,1.0)
	sprite.rotation = -0.1
