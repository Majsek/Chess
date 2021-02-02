extends "Figure.gd"

func _ready() -> void:
	name_ = "knight"
	if color_ == "white":
		self.set_rotation_degrees(Vector3(0,-90,0))
	else:
		self.set_rotation_degrees(Vector3(0,90,0))

func checkMoves():
	moves_ = []
	attack_moves_ = []
	var pos1 = position_[0]
	var pos2 = position_[1]
	var move_pos1 : int
	var move_pos2 : int
	for move_knight in [0,1]:
		move_pos1 = pos1+2+(move_knight*-1)
		move_pos2 = pos2+1+(move_knight*+1)
		ableToMove(move_pos1,move_pos2,9)

		move_pos1 = pos1+2+(move_knight*-1)
		move_pos2 = pos2-1+(move_knight*-1)
		ableToMove(move_pos1,move_pos2,7)

		move_pos1 = pos1-2+move_knight*+1
		move_pos2 = pos2+1+move_knight*+1
		ableToMove(move_pos1,move_pos2,3)

		move_pos1 = pos1-2+move_knight*+1
		move_pos2 = pos2-1+move_knight*-1
		ableToMove(move_pos1,move_pos2,1)
	checkForCheck()
