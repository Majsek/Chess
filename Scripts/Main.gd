extends Spatial

var Pawn = preload("res://Scenes/Pawn.tscn")
var Rook = preload("res://Scenes/Rook.tscn")
var Knight = preload("res://Scenes/Knight.tscn")
var Bishop = preload("res://Scenes/Bishop.tscn")
var Queen = preload("res://Scenes/Queen.tscn")
var King = preload("res://Scenes/King.tscn")
var Move = preload("res://Scenes/Move.tscn")

var map_
var select_
var mesh_
var name_

#export (PackedScene) var Pawn
#export (PackedScene) var Figure

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	map_ = []
	var map = map_
	map.resize(8)
	for pos in range(8):
		map[pos] = []
		map[pos].resize(8)
#		for pos2 in range(8):
#			map[pos][pos2] = []
#			map[pos][pos2].resize(2)
#			map[pos][pos2] = "y="+str(pos)+" "+"x="+str(pos2)
#	print(map)
	
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
	map[7][4] = B_Queen
	add_child(B_Queen)
	var W_Queen = Queen.instance()
	W_Queen.resetColor("white")
	map[0][4] = W_Queen
	add_child(W_Queen)
	
	var B_King = King.instance()
	B_King.resetColor("black")
	map[7][3] = B_King
	add_child(B_King)
	var W_King = King.instance()
	W_King.resetColor("white")
	map[0][3] = W_King
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
func getSelectPosition():
	for check in range(8):
		for check2 in range(8):
			var figure = map_[check][check2]
			if figure == select_:
				print(check,check2)
				return [check,check2]
				
func select(select):
	select_ = select
	var pos = getSelectPosition()
	var pos1 = pos[0]
	var pos2 = pos[1]
#	if name_ == "pawn":
	for move_pawn in range (2):
		var move = Move.instance()
		add_child(move)
		move.set_translation(Vector3((pos1-move_pawn-1)*3-10.5,0.7,pos2*3-10.5))

func who(name):
	name_ = name
	print(name_)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if select_:
				select_.resetColor(select_.getColor())
				
				print(select_)
				
				

#func _process(delta: float) -> void:
##	for Load in range(8):
##		for Load2 in range(8):
##			var figure = map_[Load][Load2]
##			figure.unSelectLast()
#
#
#
#	pass
