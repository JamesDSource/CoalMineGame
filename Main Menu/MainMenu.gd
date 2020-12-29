extends Control


func _on_ButtonHost_pressed():
	Network.client_name = $VBoxContainer/LineEditName.text
	Network.create_server()
	get_tree().change_scene("res://Lobby/Lobby.tscn")

func _on_ButtonConnect_pressed():
	Network.client_name = $VBoxContainer/LineEditName.text
	Network.connect_client($VBoxContainer/LineEditIP.text)
	get_tree().change_scene("res://Lobby/Lobby.tscn")
