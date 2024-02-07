extends CharacterBody2D
class_name Player

var id: int
#test

func _enter_tree():
	id = name.to_int()
	set_multiplayer_authority(id)


func _physics_process(_delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 400
		move_and_slide()
		if Input.is_action_just_pressed("ui_accept"):
			del.rpc_id(1)


@rpc("any_peer", "call_local")
func del():
	queue_free()
