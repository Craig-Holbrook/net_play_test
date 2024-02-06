extends Control

const PORT = 808
const ADDRESS = "localhost"
var peer: ENetMultiplayerPeer


func _ready():
	var upnp = UPNP.new()
	upnp.discover()
	upnp.add_port_mapping(808)
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		host_game()


#hosts external IP needs to be passed to create_client
func _on_host_pressed():
	host_game()
	send_player_information(multiplayer.get_unique_id())


func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		print("cannot host: " + error)
		return
	#try out compressions later
	peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	print("waiting for players")


func peer_connected(id: int):
	print("(I am " + str(multiplayer.get_unique_id()) + ") new peer connected " + str(id))


func peer_disconnected(id: int):
	print("(I am " + str(multiplayer.get_unique_id()) + ") peer disconnected " + str(id))


func connected_to_server():
	send_player_information.rpc_id(1, multiplayer.get_unique_id())


func connection_failed():
	print("connection failed")


@rpc("any_peer")
func send_player_information(id):
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"id": id,
		}
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(i)


@rpc("any_peer", "call_local")
func start_game():
	var stage = load("res://scenes/stage/stage.tscn").instantiate()
	get_tree().root.add_child(stage)
	self.hide()


func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ADDRESS, PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer


func _on_start_pressed():
	start_game.rpc()
