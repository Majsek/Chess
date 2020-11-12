extends Spatial

var Pawn = preload("res://Scenes/Pawn.tscn")
var Rook = preload("res://Scenes/Rook.tscn")
var Knight = preload("res://Scenes/Knight.tscn")
var Bishop = preload("res://Scenes/Bishop.tscn")
var Queen = preload("res://Scenes/Queen.tscn")
var King = preload("res://Scenes/King.tscn")

#export (PackedScene) var Pawn
#export (PackedScene) var Figure

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	var map = []
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
		B_pawn.init("black")
		map[6][Pawns] = B_pawn
		add_child(B_pawn)
		var W_pawn = Pawn.instance()
		W_pawn.init("white")
		map[1][Pawns] = W_pawn
		add_child(W_pawn)
	
	for Else in [0,7]:
		var B_Rook = Rook.instance()
		B_Rook.init("black")
		map[7][Else] = B_Rook
		add_child(B_Rook)
		var W_Rook = Rook.instance()
		W_Rook.init("white")
		map[0][Else] = W_Rook
		add_child(W_Rook)
		
		var B_Knight = Knight.instance()
		B_Knight.init("black")
		map[7][1+Else*5/7] = B_Knight
		add_child(B_Knight)
		var W_Knight = Knight.instance()
		W_Knight.init("white")
		map[0][6+Else*-5/7] = W_Knight
		add_child(W_Knight)
		
		var B_Bishop = Bishop.instance()
		B_Bishop.init("black")
		map[7][2+Else*3/7] = B_Bishop
		add_child(B_Bishop)
		var W_Bishop = Bishop.instance()
		W_Bishop.init("white")
		map[0][5+Else*-3/7] = W_Bishop
		add_child(W_Bishop)
		
	var B_Queen = Queen.instance()
	B_Queen.init("black")
	map[7][4] = B_Queen
	add_child(B_Queen)
	var W_Queen = Queen.instance()
	W_Queen.init("white")
	map[0][4] = W_Queen
	add_child(W_Queen)
	
	var B_King = King.instance()
	B_King.init("black")
	map[7][3] = B_King
	add_child(B_King)
	var W_King = King.instance()
	W_King.init("white")
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
#func _process(delta: float) -> void:
#	pass
