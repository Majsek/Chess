extends Spatial

var Pawn = preload("res://Scenes/Pawn.tscn")
var Rook = preload("res://Scenes/Rook.tscn")
var Knight = preload("res://Scenes/Knight.tscn")
var Bishop = preload("res://Scenes/Bishop.tscn")
var Queen = preload("res://Scenes/Queen.tscn")
var King = preload("res://Scenes/King.tscn")
var Move = preload("res://Scenes/Move.tscn")

var map_ = []
var figures_ = []
var white_figures_ = []
var black_figures_ = []
var select_
var mesh_
var moves_ = []
var turn_ = 0
var white_king_pos_
var black_king_pos_
var colorTurn_ = "white"
var attackers_ : Array = []
var blockers_ : Array = []
var attacking_blocker_ : Node
var castling_move_ : Node
var white_moves_ : Array = []
var black_moves_ : Array = []
var eligible_white_moves_ : Array = []
var eligible_black_moves_ : Array = []
var en_passant_move_ : Array = []
var en_passant_victim_ : Node
var promotion_ : bool = false
var promoted_pawn_ : Node
var promotion_figures_ : Array
var end_ : bool = false
var game_type_ : String
var ai_turn_ : bool = false

# Called when the node enters the scene tree for the first time.
func calledReady(game_type) -> void:
	game_type_ = game_type
	$AudioStreamPlayer_soundtrack.set("playing", true)

func _ready() -> void:

	randomize()

	drawTexture()
	colorTurnSquare()

	var map = map_
	map.resize(8)
	for pos in range(8):
		map[pos] = []
		map[pos].resize(8)

	for Pawns in range(8):
		var B_pawn = Pawn.instance()
		B_pawn.initColor("black")
		map[6][Pawns] = B_pawn
		black_figures_.append(B_pawn)
		add_child(B_pawn)
		var W_pawn = Pawn.instance()
		W_pawn.initColor("white")
		map[1][Pawns] = W_pawn
		white_figures_.append(W_pawn)
		add_child(W_pawn)

	for Else in [0,7]:
		var B_Rook = Rook.instance()
		B_Rook.initColor("black")
		map[7][Else] = B_Rook
		black_figures_.append(B_Rook)
		add_child(B_Rook)
		var W_Rook = Rook.instance()
		W_Rook.initColor("white")
		map[0][Else] = W_Rook
		white_figures_.append(W_Rook)
		add_child(W_Rook)

		var B_Knight = Knight.instance()
		B_Knight.initColor("black")
		map[7][1+Else*5/7] = B_Knight
		black_figures_.append(B_Knight)
		add_child(B_Knight)
		var W_Knight = Knight.instance()
		W_Knight.initColor("white")
		map[0][6+Else*-5/7] = W_Knight
		white_figures_.append(W_Knight)
		add_child(W_Knight)

		var B_Bishop = Bishop.instance()
		B_Bishop.initColor("black")
		map[7][2+Else*3/7] = B_Bishop
		black_figures_.append(B_Bishop)
		add_child(B_Bishop)
		var W_Bishop = Bishop.instance()
		W_Bishop.initColor("white")
		map[0][5+Else*-3/7] = W_Bishop
		white_figures_.append(W_Bishop)
		add_child(W_Bishop)

	var B_Queen = Queen.instance()
	B_Queen.initColor("black")
	map[7][3] = B_Queen
	black_figures_.append(B_Queen)
	add_child(B_Queen)
	var W_Queen = Queen.instance()
	W_Queen.initColor("white")
	map[0][3] = W_Queen
	white_figures_.append(W_Queen)
	add_child(W_Queen)

	var B_King = King.instance()
	B_King.initColor("black")
	map[7][4] = B_King
	black_figures_.append(B_King)
	add_child(B_King)
	var W_King = King.instance()
	W_King.initColor("white")
	map[0][4] = W_King
	white_figures_.append(W_King)
	add_child(W_King)

	setKingPos(7,4,"black")
	setKingPos(0,4,"white")

	print(map_)

	for Load in range(8):
		for Load2 in range(8):
			var figure = map[Load][Load2]
			if figure != null:
				figures_.append(figure)
				figure.set_translation(Vector3(Load*3-10.5,10,Load2*3-10.5))
				figure.setPosition(Load,Load2)
	checkAllMoves()
#	for PawnLoad in range(8):
#		var pawn = Figure.instance()
#		add_child(pawn)
#		pawn.set_translation(Vector3(7.5,3,PawnLoad*3-10.5))

#	figure.position =
# Called every frame. 'delta' is the elapsed time since the previous frame.
func drawTexture():
	var texture = ImageTexture.new()
	var image = Image.new()
	image.create(850, 850, false, Image.FORMAT_RGB8)
	image.fill(Color(10, 255, 255))
	image.lock() # To enable drawing with setpixel later
	for i in range(100):
		for j in range(100):
			for k in range(8):
				image.set_pixel(25+i+100*k, 25+j+100*k, Color(0, 0, 0))
			for l in range(6):
				image.set_pixel((225+i+100*l), (25+j+100*l), Color(0, 0, 0))
				image.set_pixel((25+i+100*l), (225+j+100*l), Color(0, 0, 0))
			for m in range(4):
				image.set_pixel((25+i+100*m), (425+j+100*m), Color(0, 0, 0))
				image.set_pixel((425+i+100*m), (25+j+100*m), Color(0, 0, 0))
			for n in range(2):
				image.set_pixel((25+i+100*n), (625+j+100*n), Color(0, 0, 0))
				image.set_pixel((625+i+100*n), (25+j+100*n), Color(0, 0, 0))
	for p in range(850):
		for q in range(25):
			if colorTurn_ == "white":
				image.set_pixel(p, q+825, Color(100, 100, 100))
				image.set_pixel(q+825, p, Color(100, 100, 100))
				image.set_pixel(p, q, Color(100, 100, 100))
				image.set_pixel(q, p, Color(100, 100, 100))
			if colorTurn_ == "black":
				image.set_pixel(p, q+825, Color(0, 0, 0))
				image.set_pixel(q+825, p, Color(0, 0, 0))
				image.set_pixel(p, q, Color(0, 0, 0))
				image.set_pixel(q, p, Color(0, 0, 0))
	image.unlock()
	texture.create_from_image(image)
	var mat = SpatialMaterial.new()
	mat.albedo_texture = texture
	mat.uv1_scale = Vector3(4, 4, 0)
	mat.uv1_offset = Vector3(0.5, 0, 0)
	$StaticBody/desk.set_surface_material(0, mat)
	
func colorTurnSquare():
	if colorTurn_ == "black":
		var black_mat = preload("res://Materials/pure_black_material.tres")
		$StaticBody/MeshInstance.set_surface_material(0, black_mat)
		$StaticBody/MeshInstance2.set_surface_material(0, black_mat)
		$StaticBody/MeshInstance3.set_surface_material(0, black_mat)
		$StaticBody/MeshInstance4.set_surface_material(0, black_mat)
	else:
		var white_mat = preload("res://Materials/white_material.tres")
		$StaticBody/MeshInstance.set_surface_material(0, white_mat)
		$StaticBody/MeshInstance2.set_surface_material(0, white_mat)
		$StaticBody/MeshInstance3.set_surface_material(0, white_mat)
		$StaticBody/MeshInstance4.set_surface_material(0, white_mat)

func getFromMap(pos1,pos2):
	return map_[pos1][pos2]

func checkAllMoves() -> void:
#	nefunkcni asi k hovnu
#	if attackers_ != []:
#		for attacker in attackers_:
#			attacker.checkMoves()
	for figure in figures_:
		if figure.getName() != "king":
			figure.checkMoves()
	if colorTurn_ == "black":
		map_[black_king_pos_[0]][black_king_pos_[1]].checkMoves()
		map_[white_king_pos_[0]][white_king_pos_[1]].checkMoves()
	else:
		map_[white_king_pos_[0]][white_king_pos_[1]].checkMoves()
		map_[black_king_pos_[0]][black_king_pos_[1]].checkMoves()
		
func select(select : Node, color : String):
	if end_:
			return
	if promotion_ != true:
		if colorTurn_ != color:
			return
		if !select in figures_:
			return
		for i in moves_:
			i.queue_free()
		moves_.clear()
		if castling_move_ != null:
			castling_move_.queue_free()

		select_ = select

		select.selectColor()
		var moves = select.getMoves()
		addMoves(moves)

		var castlingAvailable = castlingAvailable(color)
		if select.getName() == "king":
			if castlingAvailable[0] == true:
				addCastlingMove(select.getPosition()[0],6)
			if castlingAvailable[1] == true:
				addCastlingMove(select.getPosition()[0],2)
	else:
		var pawn_pos : Array = promoted_pawn_.getPosition()
		select.moveAnimation(pawn_pos,10)
		select.setPosition(pawn_pos[0],pawn_pos[1])
		map_[pawn_pos[0]][pawn_pos[1]] = select
		select.setZPos(10)
		select.setPromotionFalse()
		promoted_pawn_.queue_free()
		for figure in promotion_figures_:
			if figure.getPromotion():
				figure.queue_free()
		figures_.append(select)
		figures_.erase(promoted_pawn_)
		promotion_ = false
		print(select.getName())
		nextRound()


func addMoves(moves):
	for i in moves.size():
		var move = Move.instance()
		move.setPosition(moves[i])
		add_child(move)
		moves_.append(move)
		move.set_translation(Vector3(moves[i][0]*3-10.5,0.7,moves[i][1]*3-10.5))
		if map_[moves[i][0]][moves[i][1]] != null: 
			move.setMoveRed()
		if select_.getName() == "pawn" && moves[i] == en_passant_move_:
			move.setMoveRed()
			
func addCastlingMove(y_pos,x_pos):
	var castling_move = Move.instance()
	castling_move.setPosition([y_pos,x_pos])
	castling_move.setAsCastlingMove()
	castling_move.setMeshCastling()
	add_child(castling_move)
	castling_move_ = castling_move
	castling_move.set_translation(Vector3(y_pos*3-10.5,0.7,x_pos*3-10.5))

func move(move_pos) -> void:
	var move_pos1 = move_pos[0]
	var move_pos2 = move_pos[1]
	var select_pos = select_.getPosition()
	var select_name = select_.getName()
	
	for i in moves_:
		i.queue_free()
	moves_.clear()
	
	if map_[move_pos1][move_pos2] != null:
		if map_[move_pos1][move_pos2].getColor() == "white":
			white_figures_.erase(map_[move_pos1][move_pos2])
		else:
			black_figures_.erase(map_[move_pos1][move_pos2])
		map_[move_pos1][move_pos2].get_child(0).set_mode(RigidBody.MODE_RIGID)
		select_.addKillCount()
		figures_.erase(map_[move_pos1][move_pos2])
		freeFigure(map_[move_pos1][move_pos2])
		
	select_.moveAnimation(move_pos)
	map_[select_pos[0]][select_pos[1]] = null
	map_[move_pos1][move_pos2] = select_
	
	if select_name == "pawn" && move_pos == en_passant_move_:
		killEnPassantVictim()
	en_passant_move_ = []
	if select_name == "pawn" && select_.isFirstMove():
		en_passant_victim_ = select_
		if select_.getColor() == "white":
			if move_pos1 == 3:
				en_passant_move_ = [2,move_pos2]
		else:
			if move_pos1 == 4:
				en_passant_move_ = [5,move_pos2]
	else:
		if select_name == "king":
			setKingPos(move_pos1,move_pos2,select_.getColor())
			
	select_.firstMoveDone()
	select_.setPosition(move_pos1,move_pos2)
	
	$AudioStreamPlayer_move.set("playing", true)
	
	if select_name == "pawn" && (move_pos1 == 0 || move_pos1 == 7):
		promotion(select_)
	else:
		nextRound()
	
func nextRound() -> void:
#	další kolo
	attackers_ = []
	white_moves_ = []
	black_moves_ = []
	eligible_white_moves_ = []
	eligible_black_moves_ = []
	checkAllMoves()
	checkAllMoves()
	for figure in figures_:
		figure.resetBlockers()
	blockers_ = []
	nextTurn()
#	drawTexture()
	colorTurnSquare()

	for figure in white_figures_:
		if figure != null:
			eligible_white_moves_.append(figure.getMoves())
	
	for figure in black_figures_:
		if figure != null:
			eligible_black_moves_.append(figure.getMoves())
		
#	print('White')
#	print(eligible_white_moves_)
#	print('Black')
#	print(eligible_black_moves_)
	
	if colorTurn_ == "white" && !hasMoves(eligible_white_moves_):
		var reason : String
		if attackers_ != []:
			reason = "Check Mate!"
		else:
			reason = "Stale Mate!"
		theEnd(reason)
	else:
		if colorTurn_ == "black" && !hasMoves(eligible_black_moves_):
				var reason : String
				if attackers_ != []:
					reason = "Check Mate!"
				else:
					reason = "Stale Mate!"
				theEnd(reason)
	
	if game_type_ == "versus_ai":
		if !end_:
			AIMove()
			
	print(black_figures_.size())
	print(black_figures_)
	
func AIMove():
	if colorTurn_ == "black":
		ai_turn_ = true
		yield(get_tree().create_timer(1),"timeout")
		var random_select : Node = black_figures_[rand_range(0, black_figures_.size())]
		select(random_select,"black")
		while moves_ == []:
			random_select = black_figures_[rand_range(0, black_figures_.size())]
			select(random_select,"black")
			random_select.resetColor()
		move(moves_[rand_range(0, moves_.size())].getPosition())
		random_select.resetColor()
		ai_turn_ = false
		
func isAiTurn() -> bool:
		return ai_turn_
		
func hasMoves(moves: Array) -> bool:
	var has_moves := false
	for figure_moves in moves:
		if !figure_moves.empty():
			has_moves = true
	return has_moves
	
func theEnd(reason : String) -> void:
	print (reason)
	var button = Button.new()
	var label = Label.new()
	var winner := "White"
	if colorTurn_ == "white":
		winner = "Black"
	label.text = str(winner)+" won by "+reason
	button.text = "Back to menu"
	button.connect("pressed", self, "_button_pressed")
	button.set_position(Vector2(50,310))
	button.set_size(Vector2(100,50))

	label.set_position(Vector2(50,220))
	label.set_scale(Vector2(1.5,1.5))
	add_child(button)
	add_child(label)
	end_ = true
	
	$AudioStreamPlayer_soundtrack.set("playing", false)
	$AudioStreamPlayer_end.set("playing", true)
	
func _button_pressed() -> void:
	get_tree().reload_current_scene()
	
func promotion(pawn : Node) -> void:
	promoted_pawn_ = pawn
	var pawn_pos = promoted_pawn_.getPosition()
	var color = pawn.getColor()
	var promotion_queen = Queen.instance()
	var promotion_bishop = Bishop.instance()
	var promotion_knight = Knight.instance()
	var promotion_rook = Rook.instance()
	promotion_figures_ = [promotion_queen,promotion_bishop,promotion_knight,promotion_rook]
	var place : int = 2
	
	print(color+" pawn has promoted!")
	
	promotion_ = true
	
	for promotion_figure in promotion_figures_:
		promotion_figure.initPromotion()
		promotion_figure.initColor(color)
		add_child(promotion_figure)
		promotion_figure.get_child(0).set_translation(Vector3(0,-10.0+1.899977,0))
		promotion_figure.setPosition(pawn_pos[0],pawn_pos[1])
		promotion_figure.set_translation(Vector3(pawn_pos[0]*3-10.5,0,pawn_pos[1]*3-10.5))
#		promotion_figure.set_translation(Vector3(4*3-10.5,9,place*3-10.5))
		promotion_figure.moveAnimation([4,place],15)
		promotion_figure.setPosition(4,place)
		place += 1
	
	$AudioStreamPlayer_promotion.set("playing", true)

func isPromotion() -> bool:
	return promotion_

func getEnPassantMove() -> Array:
	return en_passant_move_
	
func killEnPassantVictim() -> void:
	var pos = en_passant_victim_.getPosition()
	map_[pos[0]][pos[1]] = null
	en_passant_victim_.get_child(0).set_mode(RigidBody.MODE_RIGID)
	select_.addKillCount()
	figures_.erase(en_passant_victim_)
	en_passant_victim_.queue_free()
	
func castlingMove(position):
#	rook's positions
	var old_y
	var old_x
	var new_y
	var new_x
	if position[0] == 0:
		old_y = 0
		if position[1] == 6:
			old_x = 7
			new_y = 0
			new_x = 5
		else:
			old_x = 0
			new_y = 0
			new_x = 3
	else:
		if position[0] == 7:
			old_y = 7
			if position[1] == 6:
				old_x = 7
				new_y = 7
				new_x = 5
			else:
				old_x = 0
				new_y = 7
				new_x = 3
	map_[old_y][old_x].moveAnimation([new_y,new_x])
	map_[old_y][old_x].setPosition(new_y,new_x)
	map_[new_y][new_x] = map_[old_y][old_x]
	map_[old_y][old_x] = null
	castling_move_.queue_free()
	
func setKingPos(pos1,pos2,color) -> void:
	if color == "white":
		white_king_pos_ = [pos1,pos2]
	else:
		black_king_pos_ = [pos1,pos2]

func getKingPos(color) -> Array:
	if color == "white":
		return white_king_pos_
	else:
		return black_king_pos_
		
func appendAllMoves(moves,color) -> void:
	if color == "white":
		for move in moves:
			white_moves_.append(move)
	else:
		for move in moves:
			black_moves_.append(move)
			
func getAllMoves(color) -> Array:
	if color == "white":
		return white_moves_
	else:
		return black_moves_
		
func setCheck(color,attacking_figure) -> void:
	print(color," check by ",attacking_figure.getColor()," ",attacking_figure.getName(),"!")
	attackers_.append(attacking_figure)
	
func getCheck() -> Array:
	return attackers_
	
func setBlocker(blocker : Node) -> void:
	blockers_.append(blocker)

func checkIfBlocker(blocker) -> bool:
	if blocker in blockers_:
		return true
	return false
	
func setAttackingBlocker(attacking_blocker : Node) -> void:
	attacking_blocker_ = attacking_blocker
	
func getAttackingBlocker() -> Node:
	return attacking_blocker_
	
func castlingAvailable(color) -> Array:
	var short = false
	var long = false
	var y_pos = 0
	if color == "black":
		y_pos = 7
	if map_[y_pos][4] != null && map_[y_pos][4].isFirstMove():
		if map_[y_pos][7] != null && map_[y_pos][7].isFirstMove():
			if map_[y_pos][6] == null && map_[y_pos][5] == null:
				for x_pos in range(4,7):
#					by color
					if y_pos == 0:
						short = !([y_pos,x_pos] in black_moves_)
						if !short:
							break
					else: 
						short = !([y_pos,x_pos] in white_moves_)
						if !short:
							break
		if map_[y_pos][0] != null && map_[y_pos][0].isFirstMove():
			if map_[y_pos][1] == null && map_[y_pos][2] == null && map_[y_pos][3] == null:
				for x_pos in range(2,5):
#					by color
					if y_pos == 0:
						long = !([y_pos,x_pos] in black_moves_)
						if !long:
							break
					else: 
						long = !([y_pos,x_pos] in white_moves_)
						if !long:
							break
	return [short,long]
#	if check_map_[white_king_pos_[0]][white_king_pos_[1]][1] == "black":
#		white_check_ += 1
#		print("White check")
#		if white_check_ == 2:
#			print("White check mate")
#	else:
#		white_check_ = 0
#
#	if check_map_[black_king_pos_[0]][black_king_pos_[1]][0] == "white":
#		black_check_ += 1
#		print("Black check")
#		if black_check_ == 2:
#			print("Black check mate")
#	else:
#		black_check_ = 0

#func ableToTake(pos1,pos2,color):
#	var dont
#	if (pos2 < 8 && pos2 >= 0) && (pos1 < 8 && pos1 > -1):
#		var index_color
#		if color == "white":
#			index_color = 0
#		else:
#			index_color = 1
#		if map_[pos1][pos2] == null:
#			dont = false
#			check_map_[pos1][pos2][index_color] = color
#		else:
#			dont = true
#			if map_[pos1][pos2].getColor() != color:
#
#				check_map_[pos1][pos2][index_color] = color
#	return dont

func nextTurn():
	turn_ += 1
	if turn_%2 == 0:
		colorTurn_ = "white"
	else:
		colorTurn_ = "black"
		
func freeFigure(figure):
#	select_.getPos vector rozdil aby to bylo min kdyz to je blizko
#	figure.get_node("RigidBody").add_central_force(Vector3(1000,1000,0))
	var select_pos = select_.getPosition()
	var figure_pos = figure.getPosition()
	var dif = [(figure_pos[0]-select_pos[0])*5,(figure_pos[1]-select_pos[1])*5]
	yield(get_tree().create_timer(0.7),"timeout")
	figure.get_node("RigidBody").apply_central_impulse(Vector3(dif[0],5,dif[1]))
	$AudioStreamPlayer_take.set("playing", true)
	yield(get_tree().create_timer(1.5),"timeout")
	figure.get_node("RigidBody/MeshInstance").set_visible(false)
	figure.spawnParticles()
	yield(get_tree().create_timer(5),"timeout")
	figure.queue_free()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if select_:
				yield(get_tree().create_timer(1.0/50.0),"timeout")
				select_.resetColor()
				for i in moves_:
					i.queue_free()
				moves_.clear()
				if castling_move_ != null:
					castling_move_.queue_free()


#func _process(delta: float) -> void:

#
#
#
#	pass
