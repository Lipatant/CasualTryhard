extends Game

# EXPORTS #

@export var instrument : Area2D
@export var instrument_collision_shape : CollisionShape2D
@export var note_container : Node
@export var timer : Timer

# ONREADIES #

@onready var note_resource : Resource = preload("res://src/Games/RythmHero/RythmHeroNote.tscn")

# OTHER VARIABLES #

var timer_countdown : int = 0

# INPUT #

func start() -> void:
	super.start()
	if instrument_collision_shape: instrument_collision_shape.disabled = false
	if timer: timer.start()
	_spawn_note()

func _new_click_input(_position : Vector2) -> void:
	if game_state != State.PLAYING: return
	if !instrument: return
	var note_hit : int = 0
	for note in instrument.get_overlapping_areas():
		if note is RythmHeroNote:
			note.queue_free()
			note_hit += 1
			break
	if note_hit < 1:
		game_end.emit(false)

# INPUT #

func _spawn_note() -> void:
	if !note_resource or !note_container or note_container.get_child_count() < 1 or !instrument : return
	var note_container_point : Node2D = note_container.get_children()[randi() % note_container.get_child_count()]
	if !note_container_point: return
	var note : RythmHeroNote = note_resource.instantiate()
	if !note: return
	note.target_position = instrument.global_position - note_container_point.global_position
	note_container_point.add_child(note)
	note.position = Vector2(0, 0)
	timer_countdown = (randi() % 3) + 1

func _on_timer_timeout():
	timer_countdown -= 1
	if timer_countdown < 1:
		_spawn_note()
