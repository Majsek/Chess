extends Spatial

var color_
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func init(color):
	color_ = color
	if color == "black":
		$RigidBody/MeshInstance.set_surface_material(0, preload("res://Materials/black_material.tres"))
	if color == "white":
		$RigidBody/MeshInstance.set_surface_material(0, preload("res://Materials/white_material.tres"))
func getColor():
	return color_
