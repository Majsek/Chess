extends Spatial

var Pawn = preload("res://Scenes/Pawn.tscn")
var Rook = preload("res://Scenes/Rook.tscn")
var Knight = preload("res://Scenes/Knight.tscn")
var Bishop = preload("res://Scenes/Bishop.tscn")
var Queen = preload("res://Scenes/Queen.tscn")
var King = preload("res://Scenes/King.tscn")
var Move = preload("res://Scenes/Move.tscn")

var map_ = []
var check_map_ = []
var select_
var mesh_
var name_
var moves_ = []
var moveMesh_
var turn_ = 0

#export (PackedScene) var Pawn
#export (PackedScene) var Figure

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	drawTexture()
	
	var map = map_
	map.resize(8)
	for pos in range(8):
		map[pos] = []
		map[pos].resize(8)
	
	check_map_.resize(8)
	for pos in range(8):
		check_map_[pos] = []
		check_map_[pos].resize(8)
	
	for Pawns in range(8):
		var B_pawn = Pawn.instance()
		B_pawn.resetColor("black")
		map[6][Pawns] = B_pawn
		add_child(B_pawn)
		var W_pawn = Pawn.instance()
		W_pawn.resetColor("white")
		map[1][Pawns] = W_pawn
		add_child(W_pawn)
	
	for Else in [0,7]:
		var B_Rook = Rook.instance()
		B_Rook.resetColor("black")
		map[7][Else] = B_Rook
		add_child(B_Rook)
		var W_Rook = Rook.instance()
		W_Rook.resetColor("white")
		map[0][Else] = W_Rook
		add_child(W_Rook)
		
		var B_Knight = Knight.instance()
		B_Knight.resetColor("black")
		map[7][1+Else*5/7] = B_Knight
		add_child(B_Knight)
		var W_Knight = Knight.instance()
		W_Knight.resetColor("white")
		map[0][6+Else*-5/7] = W_Knight
		add_child(W_Knight)
		
		var B_Bishop = Bishop.instance()
		B_Bishop.resetColor("black")
		map[7][2+Else*3/7] = B_Bishop
		add_child(B_Bishop)
		var W_Bishop = Bishop.instance()
		W_Bishop.resetColor("white")
		map[0][5+Else*-3/7] = W_Bishop
		add_child(W_Bishop)
		
	var B_Queen = Queen.instance()
	B_Queen.resetColor("black")
	map[7][3] = B_Queen
	add_child(B_Queen)
	var W_Queen = Queen.instance()
	W_Queen.resetColor("white")
	map[0][3] = W_Queen
	add_child(W_Queen)
	
	var B_King = King.instance()
	B_King.resetColor("black")
	map[7][4] = B_King
	add_child(B_King)
	var W_King = King.instance()
	W_King.resetColor("white")
	map[0][4] = W_King
	add_child(W_King)
	
	print(map)
	
	for Load in range(8):
		for Load2 in range(8):
			var figure = map[Load][Load2]
			if figure != null:
				figure.set_translation(Vector3(Load*3-10.5,10,Load2*3-10.5))
	

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
			if getTurn()%2 == 0:
				image.set_pixel(p, q+825, Color(100, 100, 100))
				image.set_pixel(q+825, p, Color(100, 100, 100))
				image.set_pixel(p, q, Color(100, 100, 100))
				image.set_pixel(q, p, Color(100, 100, 100))
			if getTurn()%2 != 0:
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

func getSelectPosition(select):
	for check in range(8):
		for check2 in range(8):
			if map_[check][check2] == select:
				print(check,check2)
				return [check,check2]

func select(select,color):
	var colorTurn
	if getTurn()%2 == 0:
		colorTurn = "white"
	else:
		colorTurn = "black"
	if colorTurn == color:
		for i in moves_:
			i.queue_free()
		moves_.clear()
		
		select_ = select
		var pos = getSelectPosition(select_)
		var pos1 = pos[0]
		var pos2 = pos[1]
		var move_side
		var dont1 = false
		var dont2 = false
		var dont3 = false
		var dont4 = false
		var dont5 = false
		var dont6 = false
		var dont7 = false
		var dont8 = false
		var move_position_y
		var move_position_x
		select_.getMesh().set_surface_material(0, preload("res://Materials/selected_material.tres"))
		if name_ == "pawn":
			if color == "white":
				move_side = +1
				if pos2+move_side < 8:
					if map_[pos1+move_side][pos2+move_side] != null:
						var move = Move.instance()
						move.setPosition([pos1+move_side,pos2+move_side])
						addTakeMove(pos1+move_side,pos2+move_side,color,move)
				if map_[pos1+move_side][pos2-move_side] != null:
					var move = Move.instance()
					move.setPosition([pos1+move_side,pos2-move_side])
					addTakeMove(pos1+move_side,pos2-move_side,color,move)
			if color == "black":
				move_side = -1
				if map_[pos1+move_side][pos2+move_side] != null:
					var move = Move.instance()
					move.setPosition([pos1+move_side,pos2+move_side])
					addTakeMove(pos1+move_side,pos2+move_side,color,move)
				if pos2-move_side < 8:
					if map_[pos1+move_side][pos2-move_side] != null:
						var move = Move.instance()
						move.setPosition([pos1+move_side,pos2-move_side])
						addTakeMove(pos1+move_side,pos2-move_side,color,move)
				
			for move_pawn in range (2):
				if dont1 == false:
					move_position_y = pos1+(move_pawn+1)*move_side
					move_position_x = pos2
					dont1 = addMoves(move_position_y,move_position_x,color)
					if select_.isFirstMove() == false:
						break
		if name_ == "rook":
			for move_rook in range (1,8):
				if dont1 == false:
					move_position_y = pos1-move_rook
					move_position_x = pos2
					dont1 = addMoves(move_position_y,move_position_x,color)
				if dont2 == false:
					move_position_y = pos1+move_rook
					move_position_x = pos2
					dont2 = addMoves(move_position_y,move_position_x,color)
				if dont3 == false:
					move_position_y = pos1
					move_position_x = pos2-move_rook
					dont3 = addMoves(move_position_y,move_position_x,color)
				if dont4 == false:
					move_position_y = pos1
					move_position_x = pos2+move_rook
					dont4 = addMoves(move_position_y,move_position_x,color)
		if name_ == "knight":
			for move_knight in [0,1]:
				move_position_y = pos1+2+(move_knight*-1)
				move_position_x = pos2+1+(move_knight*+1)
				addMoves(move_position_y,move_position_x,color)

				move_position_y = pos1+2+(move_knight*-1)
				move_position_x = pos2-1+(move_knight*-1)
				addMoves(move_position_y,move_position_x,color)

				move_position_y = pos1-2+move_knight*+1
				move_position_x = pos2+1+move_knight*+1
				addMoves(move_position_y,move_position_x,color)

				move_position_y = pos1-2+move_knight*+1
				move_position_x = pos2-1+move_knight*-1
				addMoves(move_position_y,move_position_x,color)
		if name_ == "bishop":
			for move_bishop in range (1,8):
				if dont1 == false:
					move_position_y = pos1-move_bishop
					move_position_x = pos2+move_bishop
					dont1 = addMoves(move_position_y,move_position_x,color)
				if dont2 == false:
					move_position_y = pos1+move_bishop
					move_position_x = pos2+move_bishop
					dont2 = addMoves(move_position_y,move_position_x,color)
				if dont3 == false:
					move_position_y = pos1+move_bishop
					move_position_x = pos2-move_bishop
					dont3 = addMoves(move_position_y,move_position_x,color)
				if dont4 == false:
					move_position_y = pos1-move_bishop
					move_position_x = pos2-move_bishop
					dont4 = addMoves(move_position_y,move_position_x,color)
		if name_ == "queen":
			for move_queen in range (1,8):
				if dont1 == false:
					move_position_y = pos1-move_queen
					move_position_x = pos2
					dont1 = addMoves(move_position_y,move_position_x,color)
				if dont2 == false:
					move_position_y = pos1+move_queen
					move_position_x = pos2
					dont2 = addMoves(move_position_y,move_position_x,color)
				if dont3 == false:
					move_position_y = pos1
					move_position_x = pos2-move_queen
					dont3 = addMoves(move_position_y,move_position_x,color)
				if dont4 == false:
					move_position_y = pos1
					move_position_x = pos2+move_queen
					dont4 = addMoves(move_position_y,move_position_x,color)
				if dont5 == false:
					move_position_y = pos1-move_queen
					move_position_x = pos2+move_queen
					dont5 = addMoves(move_position_y,move_position_x,color)
				if dont6 == false:
					move_position_y = pos1+move_queen
					move_position_x = pos2+move_queen
					dont6 = addMoves(move_position_y,move_position_x,color)
				if dont7 == false:
					move_position_y = pos1+move_queen
					move_position_x = pos2-move_queen
					dont7 = addMoves(move_position_y,move_position_x,color)
				if dont8 == false:
					move_position_y = pos1-move_queen
					move_position_x = pos2-move_queen
					dont8 = addMoves(move_position_y,move_position_x,color)
		if name_ == "king":
			move_position_y = pos1-1
			move_position_x = pos2
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1+1
			move_position_x = pos2
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1
			move_position_x = pos2-1
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1
			move_position_x = pos2+1
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1-1
			move_position_x = pos2+1
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1+1
			move_position_x = pos2+1
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1+1
			move_position_x = pos2-1
			addMoves(move_position_y,move_position_x,color)
			
			move_position_y = pos1-1
			move_position_x = pos2-1
			addMoves(move_position_y,move_position_x,color)

func addMoves(move_position_y,move_position_x,color):
	var move = Move.instance()
	var dont
	move.setPosition([move_position_y,move_position_x])
	if (move_position_x < 8 && move_position_x >= 0) && (move_position_y < 8 && move_position_y > -1):
		if map_[move_position_y][move_position_x] == null:
			add_child(move)
			moves_.append(move)
			move.set_translation(Vector3((move_position_y)*3-10.5,0.7,move_position_x*3-10.5))
			dont = false
		else:
			dont = true
			if name_ != "pawn":
				addTakeMove(move_position_y,move_position_x,color,move)
#			if name_ == "pawn":
#				don
	return dont
	
func addTakeMove(move_position_y,move_position_x,color,move):
	if map_[move_position_y][move_position_x].getColor() != color: 
	#			vyhozeni
				add_child(move)
				moves_.append(move)
				moveMesh_.set_surface_material(0, preload("res://Materials/red_material.tres"))
				move.set_translation(Vector3((move_position_y)*3-10.5,0.7,move_position_x*3-10.5))
func getMoveMesh(moveMesh):
	moveMesh_ = moveMesh

func move(move_position):
#	var map_move_position = map_[move_position[0]][move_position[1]]
	for i in moves_:
		i.queue_free()
	moves_.clear()
	if map_[move_position[0]][move_position[1]] != null:
		map_[move_position[0]][move_position[1]].get_child(0).set_mode(RigidBody.MODE_RIGID)
		select_.moveAnimation(move_position)
		
		select_.addKillCount()
		freeFigure(map_[move_position[0]][move_position[1]])
	else:
		select_.moveAnimation(move_position)
	var select_pos = getSelectPosition(select_)
	map_[select_pos[0]][select_pos[1]] = null
	map_[move_position[0]][move_position[1]] = select_
	select_.firstMoveDone()
	nextTurn()
	drawTexture()
	
	resetCheckMap()
	print(check_map_)
	
func ableToTake(pos1,pos2,color):
	var dont
	if (pos2 < 8 && pos2 >= 0) && (pos1 < 8 && pos1 > -1):
		if map_[pos1][pos2] == null:
			dont = false
			check_map_[pos1][pos2] = color
		else:
			dont = true
			checkPosition(pos1,pos2,color)
	return dont
	
func checkPosition(pos1,pos2,color):
	if map_[pos1][pos2].getColor() != color:
		check_map_[pos1][pos2] = color

func clearCheckMap():
	for i in (8):
		for l in (8):
			check_map_[i][l] = null

func resetCheckMap():
	clearCheckMap()
	for check in range(8):
		for check2 in range(8):
			if map_[check][check2] != null:
				var figure = map_[check][check2]
				var pos = getSelectPosition(figure)
				var pos1 = pos[0]
				var pos2 = pos[1]
				var figure_color = figure.getColor()
				var figure_name = figure.getName()
				var move_side
				var dont1 = false
				var dont2 = false
				var dont3 = false
				var dont4 = false
				var dont5 = false
				var dont6 = false
				var dont7 = false
				var dont8 = false
				var move_position_y
				var move_position_x
				if figure_name == "pawn":
					if figure_color == "white":
						move_side = +1
#						if pos2+move_side < 8:
#							if map_[pos1+move_side][pos2+move_side] != null:
						ableToTake(pos1+move_side,pos2+move_side,figure_color)
#						if map_[pos1+move_side][pos2-move_side] != null:
						ableToTake(pos1+move_side,pos2+move_side,figure_color)
					if figure_color == "black":
						move_side = -1
#						if map_[pos1+move_side][pos2+move_side] != null:
						ableToTake(pos1+move_side,pos2+move_side,figure_color)
#						if pos2-move_side < 8:
#							if map_[pos1+move_side][pos2-move_side] != null:
						ableToTake(pos1+move_side,pos2+move_side,figure_color)
				if figure_name == "rook":
					for move_rook in range (1,8):
						if dont1 == false:
							move_position_y = pos1-move_rook
							move_position_x = pos2
							dont1 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont2 == false:
							move_position_y = pos1+move_rook
							move_position_x = pos2
							dont2 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont3 == false:
							move_position_y = pos1
							move_position_x = pos2-move_rook
							dont3 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont4 == false:
							move_position_y = pos1
							move_position_x = pos2+move_rook
							dont4 = ableToTake(move_position_y,move_position_x,figure_color)
				if figure_name == "knight":
					for move_knight in [0,1]:
						move_position_y = pos1+2+(move_knight*-1)
						move_position_x = pos2+1+(move_knight*+1)
						ableToTake(move_position_y,move_position_x,figure_color)

						move_position_y = pos1+2+(move_knight*-1)
						move_position_x = pos2-1+(move_knight*-1)
						ableToTake(move_position_y,move_position_x,figure_color)

						move_position_y = pos1-2+move_knight*+1
						move_position_x = pos2+1+move_knight*+1
						ableToTake(move_position_y,move_position_x,figure_color)

						move_position_y = pos1-2+move_knight*+1
						move_position_x = pos2-1+move_knight*-1
						ableToTake(move_position_y,move_position_x,figure_color)
				if figure_name == "bishop":
					for move_bishop in range (1,8):
						if dont1 == false:
							move_position_y = pos1-move_bishop
							move_position_x = pos2+move_bishop
							dont1 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont2 == false:
							move_position_y = pos1+move_bishop
							move_position_x = pos2+move_bishop
							dont2 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont3 == false:
							move_position_y = pos1+move_bishop
							move_position_x = pos2-move_bishop
							dont3 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont4 == false:
							move_position_y = pos1-move_bishop
							move_position_x = pos2-move_bishop
							dont4 = ableToTake(move_position_y,move_position_x,figure_color)
				if figure_name == "queen":
					for move_queen in range (1,8):
						if dont1 == false:
							move_position_y = pos1-move_queen
							move_position_x = pos2
							dont1 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont2 == false:
							move_position_y = pos1+move_queen
							move_position_x = pos2
							dont2 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont3 == false:
							move_position_y = pos1
							move_position_x = pos2-move_queen
							dont3 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont4 == false:
							move_position_y = pos1
							move_position_x = pos2+move_queen
							dont4 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont5 == false:
							move_position_y = pos1-move_queen
							move_position_x = pos2+move_queen
							dont5 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont6 == false:
							move_position_y = pos1+move_queen
							move_position_x = pos2+move_queen
							dont6 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont7 == false:
							move_position_y = pos1+move_queen
							move_position_x = pos2-move_queen
							dont7 = ableToTake(move_position_y,move_position_x,figure_color)
						if dont8 == false:
							move_position_y = pos1-move_queen
							move_position_x = pos2-move_queen
							dont8 = ableToTake(move_position_y,move_position_x,figure_color)
				if figure_name == "king":
					move_position_y = pos1-1
					move_position_x = pos2
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1+1
					move_position_x = pos2
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1
					move_position_x = pos2-1
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1
					move_position_x = pos2+1
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1-1
					move_position_x = pos2+1
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1+1
					move_position_x = pos2+1
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1+1
					move_position_x = pos2-1
					ableToTake(move_position_y,move_position_x,figure_color)
		
					move_position_y = pos1-1
					move_position_x = pos2-1
					ableToTake(move_position_y,move_position_x,figure_color)
		
func nextTurn():
	turn_ += 1
	print(turn_)
func getTurn():
	return turn_
func freeFigure(figure):
	yield(get_tree().create_timer(2.5),"timeout")
	figure.queue_free()
func who(name):
	name_ = name
	print(name_)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if select_:
				select_.resetColor(select_.getColor())
				for i in moves_:
					i.queue_free()
				moves_.clear()


#func _process(delta: float) -> void:
##	for Load in range(8):
##		for Load2 in range(8):
##			var figure = map_[Load][Load2]
##			figure.unSelectLast()
#
#
#
#	pass
