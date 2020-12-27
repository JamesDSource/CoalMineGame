extends Control

func _process(delta):
	var label_index = 0
	for client in Network.clients:
		label_index += 1
		var player_label_node = get_node("Players/PlayerLabel" + str(label_index))
		player_label_node.text = client[1]
	
	label_index += 1
	for i in range(label_index, 5):
		var player_label_node = get_node("Players/PlayerLabel" + str(i))
		player_label_node.text = ""
