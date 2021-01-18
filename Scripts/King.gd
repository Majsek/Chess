extends "Figure.gd"

func _ready() -> void:
	name_ = "king"

func ableToMoveKing(move_pos1,move_pos2) -> bool:
	var king_dont = true
	if (move_pos2 < 8 && move_pos2 >= 0) && (move_pos1 < 8 && move_pos1 >= 0):
		for forbidden_move in all_moves_:
			if forbidden_move == [move_pos1,move_pos2]:
				king_dont = false
		var someone = get_parent().getFromMap(move_pos1,move_pos2)
		var move = [move_pos1,move_pos2]
		if someone == null:
#			addMove
			if king_dont != false:
				moves_.append(move)
			attack_moves_.append(move)
		else:
			if someone.getColor() != color_:
#					addTakeMove
				if king_dont != false:
					moves_.append(move)
			attack_moves_.append(move)
	return king_dont

func checkMoves():
	moves_ = []
	attack_moves_ = []
	all_moves_ = get_parent().getAllMoves(anti_color_)
	var pos1 = position_[0]
	var pos2 = position_[1]
	var move_pos1 : int
	var move_pos2 : int

	move_pos1 = pos1-1
	move_pos2 = pos2
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1+1
	move_pos2 = pos2
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1
	move_pos2 = pos2-1
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1
	move_pos2 = pos2+1
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1-1
	move_pos2 = pos2+1
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1+1
	move_pos2 = pos2+1
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1+1
	move_pos2 = pos2-1
	ableToMoveKing(move_pos1,move_pos2)

	move_pos1 = pos1-1
	move_pos2 = pos2-1
	ableToMoveKing(move_pos1,move_pos2)
	
	checkForCheck()
