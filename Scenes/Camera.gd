extends Camera

#onready var animation_player_ = AnimationPlayer.new()

#func moveCamera() -> void:
#	var animCamera = Animation.new()
#
#	var track_index = animCamera.add_track(Animation.TYPE_VALUE)
#	animCamera.track_set_path(track_index, "Main/Camera:translation/local")
#
#	var point1 := Vector3(-12,37.3,0)
#	var point2 := Vector3(-8,26,0)
#	var point3 := Vector3(-8,26,0)
#
#	animCamera.track_insert_key(track_index, 0.0, point1, 0.15)
#	animCamera.track_insert_key(track_index, 1.0, point2 ,0.15)
#	animCamera.track_insert_key(track_index, 2.0, point3 ,0.15)
##	set_translation(Vector3(-8,26,0))
#
#
#	animation_player_.add_animation("anim_camera", animCamera)
#	animation_player_.play("anim_camera")
