extends Game

# EXPORT #

@export var piece_container : Node
@export var move: AudioStreamPlayer

# CONST #

const _SIZE : Vector2i = Vector2i(3, 3)
const _SIZE_FLAT : int = _SIZE.x * _SIZE.y
const _COMBINATIONS : Array[Array] = [
	[0, 1, 2], [3, 4, 5], [6, 7, 8], # Lines
	[0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
	[0, 4, 8], [2, 4, 6],            # Diags
]

# OTHER VARIABLES #

var _pieces : Array[Area2D]
var _piece_count : int = _SIZE_FLAT

# READY #

func _ready() -> void:
	for child in (piece_container.get_children() if piece_container else get_children()):
		if child is TicTacToePiece:
			_pieces.append(child)
	for _i in range(_SIZE_FLAT - _pieces.size()):
		_pieces.append(null)

# INPUT #

func _new_click_input(position : Vector2) -> void:
	if game_state != State.PLAYING: return
	var piece_rect : Rect2
	for piece : TicTacToePiece in _pieces:
		if !piece or !piece.is_empty() or !piece.collision_shape or !piece.collision_shape.shape: continue
		piece_rect = piece.collision_shape.shape.get_rect()
		if !Rect2(piece.collision_shape.global_position + piece_rect.position, piece_rect.size).has_point(position):
			continue
		piece.set_value(TicTacToePiece.Value.CIRCLE)
		if move: move.play()
		_piece_count -= 1
		if _has_end():
			return
		else:
			return _enemy_move()

func _enemy_move() -> void:
	var move : TicTacToePiece = null
	var moves : Array[TicTacToePiece] = []
	for piece : TicTacToePiece in _pieces:
		if piece and piece.is_empty():
			moves.append(piece)
	if !moves.is_empty():
		move = moves[(game_manager.rng.randi() if (game_manager and game_manager.rng) else 0) % moves.size()]
	if move:
		move.set_value(TicTacToePiece.Value.CROSS)
		_piece_count -= 1
	_has_end()

func _has_end() -> bool:
	var circles : int = 0
	var crosses : int = 0
	for combination : Array in _COMBINATIONS:
		circles = 0
		crosses = 0
		for piece in combination:
			if !_pieces[piece] or _pieces[piece].is_empty():
				continue
			if _pieces[piece].get_value() == TicTacToePiece.Value.CIRCLE:
				circles += 1
			if _pieces[piece].get_value() == TicTacToePiece.Value.CROSS:
				crosses += 1
		if circles >= 3 or crosses >= 3:
			for piece in range(_SIZE_FLAT):
				if piece in combination or !_pieces[piece]: continue
				_pieces[piece].set_value()
			if circles >= 3:
				game_end.emit(true)
				return true
			if crosses >= 3:
				game_end.emit(false)
				return true
	if _piece_count < 1:
		game_end.emit(true)
		return true
	return false
