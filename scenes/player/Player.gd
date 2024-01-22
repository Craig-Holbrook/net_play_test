extends CharacterBody2D
class_name Player

var id: int


func _ready():
	set_multiplayer_authority(id)


func _physics_process(delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 400
		move_and_slide()
