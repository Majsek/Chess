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
var en_passant_move_ : Array = []
var en_passant_victim_ : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

	drawTexture()

	var map = map_
	map.resize(8)
	for pos in range(8):
		map[pos] = []
		map[pos].resize(8)

	for Pawns in range(8):
		var B_pawn = Pawn.instance()
		B_pawn.initColor("black")
		map[6][Pawns] = B_pawn
		add_child(B_pawn)
		var W_pawn = Pawn.instance()
		W_pawn.initColor("white")
		map[1][Pawns] = W_pawn
		add_child(W_pawn)

	for Else in [0,7]:
		var B_Rook = Rook.instance()
		B_Rook.initColor("black")
		map[7][Else] = B_Rook
		add_child(B_Rook)
		var W_Rook = Rook.instance()
		W_Rook.initColor("white")
		map[0][Else] = W_Rook
		add_child(W_Rook)

		var B_Knight = Knight.instance()
		B_Knight.initColor("black")
		map[7][1+Else*5/7] = B_Knight
		add_child(B_Knight)
		var W_Knight = Knight.instance()
		W_Knight.initColor("white")
		map[0][6+Else*-5/7] = W_Knight
		add_child(W_Knight)

		var B_Bishop = Bishop.instance()
		B_Bishop.initColor("black")
		map[7][2+Else*3/7] = B_Bishop
		add_child(B_Bishop)
		var W_Bishop = Bishop.instance()
		W_Bishop.initColor("white")
		map[0][5+Else*-3/7] = W_Bishop
		add_child(W_Bishop)

	var B_Queen = Queen.instance()
	B_Queen.initColor("black")
	map[7][3] = B_Queen
	add_child(B_Queen)
	var W_Queen = Queen.instance()
	W_Queen.initColor("white")
	map[0][3] = W_Queen
	add_child(W_Queen)

	var B_King = King.instance()
	B_King.initColor("black")
	map[7][4] = B_King
	add_child(B_King)
	var W_King = King.instance()
	W_King.initColor("white")
	map[0][4] = W_King
	add_child(W_King)

	setKingPos(7,4,"black")
	setKingPos(0,4,"white")

	print(map)

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
		
func select(select,color):
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


func addMoves(moves):
	for i in moves.size():
		var move = Move.instance()
		move.setPosition(moves[i])
		add_child(move)
		moves_.append(move)
		move.set_translation(Vector3(moves[i][0]*3-10.5,0.7,moves[i][1]*3-10.5))
		if map_[moves[i][0]][moves[i][1]] != null: 
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
	
#	další kolo
	attackers_ = []
	white_moves_ = []
	black_moves_ = []
	checkAllMoves()
	checkAllMoves()
	for figure in figures_:
		figure.resetBlockers()
	blockers_ = []
	nextTurn()
	drawTexture()

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
				short = true
		if map_[y_pos][0] != null && map_[y_pos][0].isFirstMove():
			if map_[y_pos][1] == null && map_[y_pos][2] == null && map_[y_pos][3] == null:
				long = true
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
	yield(get_tree().create_timer(3.3),"timeout")
	figure.queue_free()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if select_:
				select_.resetColor()
				for i in moves_:
					i.queue_free()
				moves_.clear()
				if castling_move_ != null:
					castling_move_.queue_free()


#func _process(delta: float) -> void:
##	for Load in range(8):
##		for Load2 in range(8):
##			var figure = map_[Load][Load2]
##			figure.unSelectLast()
#
#
#
#	pass
