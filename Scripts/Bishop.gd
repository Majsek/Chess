extends "Figure.gd"

func _ready() -> void:
	name_ = "bishop"

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
	for move_bishop in range (1,8):
			if dont1[1] == false:
				move_pos1 = pos1-move_bishop
				move_pos2 = pos2+move_bishop
				dont1 = ableToMove(move_pos1,move_pos2,3,dont1)
			if dont2[1] == false:
				move_pos1 = pos1+move_bishop
				move_pos2 = pos2+move_bishop
				dont2 = ableToMove(move_pos1,move_pos2,9,dont2)
			if dont3[1] == false:
				move_pos1 = pos1+move_bishop
				move_pos2 = pos2-move_bishop
				dont3 = ableToMove(move_pos1,move_pos2,7,dont3)
			if dont4[1] == false:
				move_pos1 = pos1-move_bishop
				move_pos2 = pos2-move_bishop
				dont4 = ableToMove(move_pos1,move_pos2,1,dont4)
	checkForCheck()
