extends Spatial

var color_
var selected_
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

func select(selected):
	selected_ = selected
	if selected == true:
		$RigidBody/MeshInstance.set_surface_material(0, preload("res://Materials/selected_material.tres"))
	else:
		init(getColor())

func _on_RigidBody_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		var name = get_name()
		var instance = get_instance_id()
		var spatial = get_parent_spatial()
		print(name)
		print(instance)
		print(spatial)
#		set_translation(Vector3(3-10.5,10,3-10.5))
		print (color_)
		select(true)
		print(selected_)
