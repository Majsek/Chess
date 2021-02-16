extends Spatial

var particles_ = preload("res://Scenes/Particles.tscn")

var color_ : String
var anti_color_ : String
var position_ : Array = []
var select_ : Node
var first_move_ : bool = true
var kill_count_ = 0
var moves_ : Array = []
var name_ : String
var all_moves_ : Array = []
var attack_moves_ : Array = []
var blockers_ : Array = [null,null,null,null,null,null,null,null,null,null]
var allowedDirection_ : int = 0
var promotion_ : bool = false
var z_pos_ : int = 10
onready var parent_ = get_parent()
onready var animation_player_ = AnimationPlayer.new()

func _ready() -> void:
	add_child(animation_player_)
	if promotion_ == false:
		yield(get_tree().create_timer(2),"timeout")
		$RigidBody.set_mode(RigidBody.MODE_STATIC)	
	else:	
		setZPos(15)
		$RigidBody.set_mode(RigidBody.MODE_STATIC)
		
		
func initPromotion() -> void:
	promotion_ = true
	
func setPromotionFalse() -> void:
	promotion_ = false
	
func getPromotion() -> bool:
	return promotion_
	
func setZPos(value : int):
	z_pos_ = value
	
func initColor(color) -> void:
	color_ = color
	if color == "white":
		anti_color_ = "black"
	else: anti_color_ = "white"
	resetColor()
	
func resetColor() -> void:
	if color_ == "black":
		getMesh().set_surface_material(0, preload("res://Materials/black_material.tres"))
	if color_ == "white":
		getMesh().set_surface_material(0, preload("res://Materials/white_material.tres"))

func selectColor() -> void:
	if !parent_.isAiTurn():
		getMesh().set_surface_material(0, preload("res://Materials/selected_material.tres"))

func setPosition(pos1, pos2) -> void:
	position_ = [pos1, pos2]

func getPosition() -> Array:
	return position_

func getColor() -> String:
	return color_

func getMesh() -> Node:
	return $RigidBody/MeshInstance
	
func getName() -> String:
	return name_
	
func firstMoveDone() -> void:
	first_move_ = false
	
func isFirstMove() -> bool:
	return first_move_
	
func addKillCount() -> void:
	kill_count_ += 1
	if kill_count_ == 2:
		print("Doublekill!")
	else: if kill_count_ == 3:
		print("Tripplekill!")
	else: if kill_count_ == 4:
		print("Quadrakill!")
	else: if kill_count_ == 5:
		print("Pentakill!")
	else: if kill_count_ == 6:
		print("Hexakill")
	
func getKillCount() -> int:
	return kill_count_

func moveAnimation(move_position, z_pos_received : float = 10) -> void:
	var previous_position = getPosition()
	var anim = Animation.new()
	
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, ":translation")
	
	var point1 := Vector3(previous_position[0]*3-10.5,z_pos_,previous_position[1]*3-10.5)
#	var point2 := Vector3(previous_position[0]+*3-10.5,15,previous_position[1]*3-10.5)
	var point3 := Vector3(move_position[0]*3-10.5,z_pos_received,move_position[1]*3-10.5)
	if promotion_ == false:
		var point2 := Vector3((point1.x+point3.x)/2.0,13,(point1.z+point3.z)/2.0)
		anim.track_insert_key(track_index, 0.5, point2, 0.2)
	
	anim.track_insert_key(track_index, 0.0, point1, 0.3)
	anim.track_insert_key(track_index, 1, point3 ,0.15)
	
	animation_player_.add_animation("anim_name", anim)
	animation_player_.play("anim_name")
	
func ableToMove(move_pos1, move_pos2, direction, dont : Array = [false,false]) -> Array:
	if parent_.checkIfBlocker(self):
		print(color_ + name_ + "is blocking the King!")
		if name_ == "knight":
			return[true,true]
		# !(allowedDirection_ == 0 || direction == allowedDirection_)
		#return 
		if !(allowedDirection_ == 0 || direction == allowedDirection_ || direction == reverseDirection(allowedDirection_)):
			return [true,true]
	else:
		allowedDirection_ = 0
	if (move_pos2 < 8 && move_pos2 >= 0) && (move_pos1 < 8 && move_pos1 >= 0):
		var move = [move_pos1,move_pos2]
		var attackers = parent_.getCheck()
		var dont3 : bool = false
		if attackers != []:
			for attacker in attackers:
				if attacker.getColor() != color_:
					var attacker_pos = attacker.getPosition()
					var king_pos = parent_.getKingPos(color_)
					var attacker_moves = attacker.getMoves()
					attacker_moves.append(attacker.getPosition())
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
								
		var someone = parent_.getFromMap(move_pos1,move_pos2)
		if someone == null:
			if dont[0] == false:
				if dont3 == false:
					moves_.append(move)
			
#			attack_moves_.append(move)
				attack_moves_.append(move)
#			else:
#				attack_moves_.append(move)

		else:
			if someone.getColor() != color_:
				if dont[0] == false:
					if dont3 == false:
						moves_.append(move)
					dont[0] = true
				
				if someone.getName() != "king":
					blockers_[direction] = someone
#					if blockers_[direction] == null:
#						blockers_[direction] = someone
#					else:
#						blockers_[direction] = null
				else:
#					dont[1] = true
					if blockers_[direction] != null:
						parent_.setAttackingBlocker(self)
						parent_.setBlocker(blockers_[direction])
						blockers_[direction].setAllowedDirection(direction)
						dont[1] = true
					else:
						dont[0] = false

			else:
				attack_moves_.append(move)
				dont[1] = true
#				check_blocking_ = false
#			if check_blocking_ == false:
#				attack_moves_.append(move)
#			attack_moves_.append(move)
	return dont
	
func setAllowedDirection(direction) -> void:
	allowedDirection_ = direction
	
func reverseDirection(direction : int) -> int:
	return 10 - direction
	
func resetBlockers() -> void:
	blockers_ = [null,null,null,null,null,null,null,null,null,null]
	
#func ableToMove(move_pos1,move_pos2) -> bool:
#	var dont = true
#	if (move_pos2 < 8 && move_pos2 >= 0) && (move_pos1 < 8 && move_pos1 >= 0):
#		var someone = parent_.getFromMap(move_pos1,move_pos2)
#		var move = [move_pos1,move_pos2]
#		if someone == null:
##			addMove
#			moves_.append(move)
#			dont = false
#		else:
#			dont = true
#			if someone.getColor() != color_:
##					addTakeMove
#				moves_.append(move)
#				if someone.getName() != "king":
#					pass
#			attack_moves_.append(move)
#	return dont

func checkForCheck() -> void:
	if moves_ != [] || attack_moves_ != []:
		parent_.appendAllMoves(moves_,color_)
		parent_.appendAllMoves(attack_moves_,color_)
		for move in moves_:
			if parent_.getKingPos(anti_color_) == move:
				parent_.setCheck(anti_color_,self)
			
func getMoves() -> Array:
	return moves_
	
func spawnParticles() -> void:
	var particle = particles_.instance()
	particle.set_mesh($RigidBody/MeshInstance.mesh)
	particle.set_emitting(true)
	$RigidBody.set_mode(RigidBody.MODE_STATIC)
	$RigidBody.set_rotation_degrees(Vector3(0,0,0))
	$RigidBody.add_child(particle)
	
		
func _on_RigidBody_input_event(_camera: Node, _event: InputEvent, _click_position: Vector3, _click_normal: Vector3, _shape_idx: int) -> void:
	if _event.is_pressed():
		if parent_.isPromotion():
			if !promotion_:
				return
		if !parent_.isAiTurn():
			parent_.select(self,getColor())
		
		
#		zapise se do pole seznam movu tim smerem kde k tomu dojde, ten potom prida jako jediny moves, co bude mit blocker
#		kazdej to bere postupne a stridaj se mu smery, proto to nefunguje, nejsou smery zasebou
