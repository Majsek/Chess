extends Spatial

var color_
var select_
var first_move_ := true
var kill_count_ = 0
onready var animation_player_ = AnimationPlayer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(2.5),"timeout")
	$RigidBody.set_mode(RigidBody.MODE_STATIC)
	add_child(animation_player_)
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
	
func firstMoveDone():
	first_move_ = false
	
func isFirstMove() -> bool:
	return first_move_
	
func addKillCount():
	kill_count_ += 1
	if kill_count_ == 2:
		print("Doublekill!")
	else: if kill_count_ == 3:
		print("Tripplekill!")
	else: if kill_count_ == 4:
		print("Quadrakill!")
	else: if kill_count_ == 5:
		print("Pentakill!")
	else: if kill_count_ == 6:
		print("Hexakill")
	
func getKillCount():
	return kill_count_


func moveAnimation(move_position):
	var previous_position = get_parent().getSelectPosition()
	var anim = Animation.new()
	
	var track_index = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_index, ":translation")
	anim.track_insert_key(track_index, 0.0,
	Vector3(previous_position[0]*3-10.5,10,previous_position[1]*3-10.5), 0.15)
	anim.track_insert_key(track_index, 1,
	Vector3(move_position[0]*3-10.5,10,move_position[1]*3-10.5),0.15)
#	translation = Vector3(move_position[0]*3-10.5,10,move_position[1]*3-10.5)
	animation_player_.add_animation("anim_name", anim)
	animation_player_.play("anim_name")
	
func _on_RigidBody_input_event(camera: Node, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
	if event.is_pressed():
		get_parent().select(self,getColor())
		
