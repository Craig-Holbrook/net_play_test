extends Node


func _ready():
	spawn_old()
	multiplayer.peer_disconnected.connect(del_player)

	#await get_tree().create_timer(3.0).timeout
	#if multiplayer.get_unique_id() == 1:
	#del.rpc()


func del_player(id: int):
	if multiplayer.is_server():
		if get_node(str(id)):
			get_node(str(id)).queue_free()


@rpc("any_peer", "call_local")
func del():
	get_tree().get_first_node_in_group("player").queue_free()


func spawn_old():
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
		print(player.id)
		player.global_position = spawns[index].global_position
		index += 1
