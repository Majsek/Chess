extends Spatial

var Pawn = preload("res://Pawn.tscn")

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
		for pos2 in range(8):
			map[pos][pos2] = []
			map[pos][pos2].resize(2)
#			map[pos][pos2] = "y="+str(pos)+" "+"x="+str(pos2)
#	print(map)
	
	for Pawns in range(8):
		var W_pawn = Pawn.instance()
		W_pawn.init("white")
		map[1][Pawns][1] = W_pawn
		add_child(W_pawn)
		var B_pawn = Pawn.instance()
		B_pawn.init("black")
		map[6][Pawns][1] = B_pawn
		add_child(B_pawn)
		
	print(map)
	
	
#	for PawnLoad in range(8):
#		var pawn = Figure.instance()
#		add_child(pawn)
#		pawn.set_translation(Vector3(7.5,3,PawnLoad*3-10.5))

#	figure.position =
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
