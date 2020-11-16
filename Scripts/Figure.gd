extends Spatial

var color_
var select_


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize() # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func resetColor(color):
	color_ = color
	if color == "black":
		getMesh().set_surface_material(0, preload("res://Materials/black_material.tres"))
	if color == "white":
		getMesh().set_surface_material(0, preload("res://Materials/white_material.tres"))

func getColor():
	return color_

func getMesh():
	return $RigidBody/MeshInstance

func _on_RigidBody_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		get_parent().select(self)
		getMesh().set_surface_material(0, preload("res://Materials/selected_material.tres"))
