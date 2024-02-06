extends Node


func _ready():
	spawn()
	multiplayer.peer_disconnected.connect(del_player)


func del_player(id: int):
	if multiplayer.is_server():
		if has_node(str(id)):
			get_node(str(id)).queue_free()


func spawn():
	if not multiplayer.is_server():
		return

	for id in GameManager.players:
		var current_player: Player = load("res://scenes/player/player.tscn").instantiate()
		current_player.name = str(id)
		add_child(current_player, true)
	spawn_pos.rpc()


@rpc("any_peer", "call_local")
func spawn_pos():
	var index = 0
	var spawns = get_tree().get_nodes_in_group("spawn_points")
	for player: Player in get_tree().get_nodes_in_group("player"):
		player.global_position = spawns[index].global_position
		index += 1
