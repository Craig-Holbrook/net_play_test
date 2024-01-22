extends Node

@onready var player_scene: PackedScene = load("res://scenes/player/player.tscn")


func _ready():
	var index = 0
	for i in GameManager.players:
		var current_player: Player = player_scene.instantiate()
		current_player.id = GameManager.players[i].id
		add_child(current_player)
		for spawn in get_tree().get_nodes_in_group("spawn_points"):
			if spawn.name == str(index):
				current_player.global_position = spawn.global_position
		index += 1
