extends Spatial

var position_


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setPosition(position):
	position_ = position

func _on_Area_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		get_parent().move(position_)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
