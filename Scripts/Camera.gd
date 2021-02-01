extends Camera

onready var animation_player_ = AnimationPlayer.new()

func _ready() -> void:
	add_child(animation_player_)

func moveCamera() -> void:
	var animCamera = Animation.new()

	var track_translation = animCamera.add_track(Animation.TYPE_VALUE)
	var track_rotation = animCamera.add_track(Animation.TYPE_VALUE)
	animCamera.track_set_path(track_translation, ":translation")
	animCamera.track_set_path(track_rotation, ":rotation_degrees")

	var translation1 := Vector3(-12,37.3,0)
	var translation2 := Vector3(-12,37.3,0)
	var translation3 := Vector3(-8,26,0)

	var rotation1 := Vector3(0,-90,0)
	var rotation2 := Vector3(-75,-90,0)

#	animCamera.track_set_key_time(track_translation, translation1, 1)
#	animation_player_.length = 5
	animation_player_.playback_speed = 0.4

	animCamera.track_insert_key(track_translation, 0.0, translation1, 0.15)
	animCamera.track_insert_key(track_translation, 0.5, translation2, 0.15)
	animCamera.track_insert_key(track_translation, 1.0, translation3, 0.15)
	
	
	
	animCamera.track_insert_key(track_rotation, 0.0, rotation1, 0.5)
	animCamera.track_insert_key(track_rotation, 0.4, rotation2 ,0.15)


	animation_player_.add_animation("anim_camera", animCamera)
	animation_player_.play("anim_camera")
