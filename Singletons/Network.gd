extends Node

const PORT = 9785
const MAX_PLAYERS = 4

onready var peer = NetworkedMultiplayerENet.new()

# Client class that hold all client info
class Client:
	var id = ""
	var client_name = ""
	func _init(id, client_name):
		self.id = id
		self.client_name = client_name

var clients = []

func _ready():
	# setting some signals
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

# functions for managing the server/client
func create_server():
	peer.create_server(PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func connect_client(ip):
	peer.create_client(ip, PORT)
	get_tree().network_peer = peer

func network_disconnect():
	get_tree().network_peer = null


# some signals
func _player_connected(id):
	if get_tree().is_network_server():
		clients.append(Client.new(id, "Player"))
		rset("clients", clients)

func _player_disconnected(id):
	if get_tree().is_network_server():
		for client in clients:
			if client.id == id:
				clients.erase(client)
				rset("clients", clients)
				break
