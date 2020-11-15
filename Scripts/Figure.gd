extends Spatial

var color_
var selected_
var last_selected_
var last_color_
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
	last_selected_ = selected
	last_color_ = getColor()
	$RigidBody/MeshInstance.set_surface_material(0, preload("res://Materials/selected_material.tres"))

func unSelectLast():
	if last_color_ == "black":
		print(last_selected_)
		last_selected_.set_surface_material(0, preload("res://Materials/black_material.tres"))
	if last_color_ == "white":
		last_selected_.set_surface_material(0, preload("res://Materials/white_material.tres"))
		print(last_selected_)

func whoSelected():
	return selected_

func _on_RigidBody_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		var name = get_name()
		var instance = get_instance_id()
		var spatial = get_parent_spatial()
#		print(name)
#		print(instance)
#		print(spatial)
#		set_translation(Vector3(3-10.5,10,3-10.5))
#		print (color_)
		unSelectLast()
		select($RigidBody/MeshInstance)
#		print(selected_)
#		print($RigidBody/MeshInstance)
		
