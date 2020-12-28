extends Node

const PORT = 9785
const MAX_PLAYERS = 4

sync var clients = []
var client_name = ""

func _ready():
	# setting some signals
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

# functions for managing the server/client
func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	
	_player_connected(get_tree().get_network_unique_id())

func connect_client(ip):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORT)
	get_tree().network_peer = peer

func network_disconnect():
	get_tree().network_peer = null
	clients = []

# synced network functions
sync func _force_disconnect(message):
	pass

sync func _set_player_name(player_name):
	var sender_id = get_tree().get_rpc_sender_id()
	var index = 0
	for client in clients:
		if client[0] == sender_id:
			clients[index] = [sender_id, player_name]
			rset("clients", clients)
			break
		index = index + 1

sync func _request_player_name():
	rpc_id(1, "_set_player_name", client_name)


# signals
func _server_disconnected():
	network_disconnect()
	get_tree().change_scene("res://Main Menu/MainMenu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _player_connected(id):
	if get_tree().is_network_server():
		clients.append([id, "Player Name"])
		rset("clients", clients)
		rpc_id(id, "_request_player_name")

func _player_disconnected(id):
	if get_tree().is_network_server():
		for client in clients:
			if client[0] == id:
				clients.erase(client)
				rset("clients", clients)
				break
