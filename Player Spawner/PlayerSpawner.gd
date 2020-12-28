tool
extends Spatial

export var spawn_points = 4 setget spawn_points_changed


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
