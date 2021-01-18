extends "Figure.gd"

func _ready() -> void:
	name_ = "rook"

func checkMoves():
	moves_ = []
	attack_moves_ = []
	var pos1 = position_[0]
	var pos2 = position_[1]
	var dont1 : Array = [false,false]
	var dont2 : Array = [false,false]
	var dont3 : Array = [false,false]
	var dont4 : Array = [false,false]
	var move_pos1 : int
	var move_pos2 : int
	for move_rook in range (1,8):
			if dont1[1] == false:
				move_pos1 = pos1-move_rook
				dont1 = ableToMove(move_pos1,pos2,2,dont1)
			if dont2[1] == false:
				move_pos1 = pos1+move_rook
				dont2 = ableToMove(move_pos1,pos2,8,dont2)
			if dont3[1] == false:
				move_pos2 = pos2-move_rook
				dont3 = ableToMove(pos1,move_pos2,4,dont3)
			if dont4[1] == false:
				move_pos2 = pos2+move_rook
				dont4 = ableToMove(pos1,move_pos2,6,dont4)
	checkForCheck()
