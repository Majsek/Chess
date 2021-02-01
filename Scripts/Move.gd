extends Spatial

var position_ : Array
var castling_move_ : bool = false
func _ready() -> void:
	if get_parent().isAiTurn():
		$MeshInstance.set_visible(false)
	
func setPosition(position : Array) -> void:
	position_ = position
	
func getPosition() -> Array:
	return position_
	
func setAsCastlingMove() -> void:
	castling_move_ = true

func setMoveRed() -> void:
	$MeshInstance.set_surface_material(0, preload("res://Materials/red_material.tres"))
	$Area/CollisionShape.set_shape(preload("res://Shapes/move_shape_red.tres"))
	
func setMeshCastling() -> void:
	$MeshInstance.set_surface_material(0, preload("res://Materials/selected_material.tres"))

func _on_Area_input_event(_camera: Node, _event: InputEvent, _click_position: Vector3, _click_normal: Vector3, _shape_idx: int) -> void:
	if _event.is_pressed():
		if castling_move_ == true:
			get_parent().castlingMove(position_)
		get_parent().move(position_)
