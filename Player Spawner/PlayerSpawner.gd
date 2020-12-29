tool
extends Spatial

export var spawn_points = 4 setget spawn_points_changed

var spawned = false

func spawn_points_changed(sp):
	if Engine.editor_hint:
		spawn_points = sp
		
		var children = get_children()
		for child in children:
			remove_child(child)
		
		for i in range(0, spawn_points):
			var position = Position3D.new()
			position.name = "SpawnPoint" + str(i + 1)
			add_child(position)
			position.set_owner(get_tree().get_edited_scene_root())

func _process(delta):
	if !Engine.editor_hint && !spawned:
		var clients = Network.clients
		var player = load("res://Player/Player.tscn")
		var index = 1
		for client in clients:
			var player_inst = player.instance()
			get_tree().root.add_child(player_inst)
			var spawn = get_node("SpawnPoint" + str(index))
			player_inst.global_transform.origin = spawn.global_transform.origin
			player_inst.set_network_master(client[0])
			player_inst.name = client[1] + str(client[0])
			index += 1
		spawned = true
