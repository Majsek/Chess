extends "Figure.gd"

func _ready() -> void:
	name_ = "queen"

func checkMoves():
	moves_ = []
	attack_moves_ = []
	var pos1 = position_[0]
	var pos2 = position_[1]
	var dont1 : Array = [false,false]
	var dont2 : Array = [false,false]
	var dont3 : Array = [false,false]
	var dont4 : Array = [false,false]
	var dont5 : Array = [false,false]
	var dont6 : Array = [false,false]
	var dont7 : Array = [false,false]
	var dont8 : Array = [false,false]
	var move_pos1 : int
	var move_pos2 : int
	for move_queen in range (1,8):
		if dont1[1] == false:
			move_pos1 = pos1-move_queen
			move_pos2 = pos2
			dont1 = ableToMove(move_pos1,move_pos2,2,dont1)
		if dont2[1] == false:
			move_pos1 = pos1+move_queen
			move_pos2 = pos2
			dont2 = ableToMove(move_pos1,move_pos2,8,dont2)
		if dont3[1] == false:
			move_pos1 = pos1
			move_pos2 = pos2-move_queen
			dont3 = ableToMove(move_pos1,move_pos2,4,dont3)
		if dont4[1] == false:
			move_pos1 = pos1
			move_pos2 = pos2+move_queen
			dont4 = ableToMove(move_pos1,move_pos2,6,dont4)
		if dont5[1] == false:
			move_pos1 = pos1-move_queen
			move_pos2 = pos2+move_queen
			dont5 = ableToMove(move_pos1,move_pos2,3,dont5)
		if dont6[1] == false:
			move_pos1 = pos1+move_queen
			move_pos2 = pos2+move_queen
			dont6 = ableToMove(move_pos1,move_pos2,9,dont6)
		if dont7[1] == false:
			move_pos1 = pos1+move_queen
			move_pos2 = pos2-move_queen
			dont7 = ableToMove(move_pos1,move_pos2,7,dont7)
		if dont8[1] == false:
			move_pos1 = pos1-move_queen
			move_pos2 = pos2-move_queen
			dont8 = ableToMove(move_pos1,move_pos2,1,dont8)
	checkForCheck()
