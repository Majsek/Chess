extends "Figure.gd"

func _ready() -> void:
	name_ = "pawn"
	
func ableToMovePawn(move_pos1,move_pos2) -> bool:
	var dont = true
	if get_parent().checkIfBlocker(self):
		print(color_ + name_ + "is blocking the King!")
		if get_parent().getAttackingBlocker().getPosition() != [move_pos1,move_pos2] :
			if allowedDirection_ != 8 || allowedDirection_ != 2:
				print(allowedDirection_)
				return dont
	if (move_pos2 < 8 && move_pos2 >= 0) && (move_pos1 < 8 && move_pos1 >= 0):
		var move = [move_pos1,move_pos2]
		var attackers = get_parent().getCheck()
		var dont3 : bool = false
		if attackers != []:
			if attackers[0].getColor() != color_:
				var attacker_pos = attackers[0].getPosition()
				var king_pos = get_parent().getKingPos(color_)
				var attacker_moves = attackers[0].getMoves()
				attacker_moves.append(attackers[0].getPosition())
				if !move in attacker_moves:
					dont3 = true
					
				if dont3 == false:
					var smaller = king_pos
					var bigger = attacker_pos
					if attacker_pos[0] == king_pos[0]:
						if move_pos1 != king_pos[0]:
							dont3 = true
						else: 
							if attacker_pos[1] < king_pos[1]:
								smaller = attacker_pos
								bigger = king_pos
							if move_pos2 < smaller[1]:
								dont3 = true
							if move_pos2 > bigger[1]:
								dont3 = true
					else:
						if attacker_pos[1] == king_pos[1]:
							if move_pos2 != king_pos[1]:
								dont3 = true
							else:
								if attacker_pos[0] < king_pos[0]:
									smaller = attacker_pos
									bigger = king_pos
								if move_pos1 < smaller[0]:
									dont3 = true
								if move_pos1 > bigger[0]:
									dont3 = true
						else:
							var minus = +1
							if attacker_pos[0] < king_pos[0]:
								smaller = attacker_pos
								bigger = king_pos
							if smaller[1] > bigger[1]:
									minus = -1
	#							if attacker_pos[1] < king_pos[1]:
	#								smaller = attacker_pos
	#								bigger = king_pos
							var difference = bigger[0] - smaller[0]
							for i in range (difference):
								if move_pos1 == (smaller[0] + i) && move_pos2 == (smaller[1] + i*minus):
									dont3 = false
									break
								else: 
									dont3 = true
			
		var someone = get_parent().getFromMap(move_pos1,move_pos2)
		if someone == null:
			if get_parent().getEnPassantMove() == [move_pos1,move_pos2]:
				moves_.append(move)
			if move_pos2 == position_[1]:
	#			addMove
				if dont3 == false:
					moves_.append(move)
				dont = false
		else:
			dont = true
			if move_pos2 != position_[1]: 
				if someone.getColor() != color_:
	#					addTakeMove
					if dont3 == false:
						moves_.append(move)
		if move_pos2 != position_[1]:
			attack_moves_.append(move)
	return dont

func checkMoves():
	moves_ = []
	attack_moves_ = []
	var pos1 = position_[0]
	var pos2 = position_[1]
	var dont1 : bool = false
	var move_side : int
	if color_ == "white":
		move_side = +1
	if color_ == "black":
		move_side = -1
	ableToMovePawn(pos1+move_side,pos2+move_side)
	ableToMovePawn(pos1+move_side,pos2-move_side)
	for move_pawn in range (2):
			if dont1 == false:
				dont1 = ableToMovePawn(pos1+(move_pawn+1)*move_side,pos2)
				if isFirstMove() == false:
					break
	if attack_moves_ != []:
		get_parent().appendAllMoves(attack_moves_,color_)
		for move in attack_moves_:
				if get_parent().getKingPos(anti_color_) == move:
					get_parent().setCheck(anti_color_,self)
