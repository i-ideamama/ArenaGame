extends Control

@export var Address = "127.0.0.1"

var peer
const PORT = Constants.PORT
const DEFAULT_SERVER_IP = Constants.SERVER_IP

@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://Scenes/Football/football_maingame.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
# called only server and clients
func peer_connected(id):
	print("Player connected " +  str(id))

# called only server and clients
func peer_disconnected(id):
	print("Player disconnected " +  str(id))

# called only on clients
# can be used to send custom info
func connected_to_server():
	print("Connected to server.")
	SendPlayerInformation.rpc_id(1,$LineEdit.text,multiplayer.get_unique_id())

# called only on clients
# can be used to send custom info
func connection_failed():
	print("Couldn't connect.")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if(!FbGameManager.Players.has(id)):
		FbGameManager.Players[id] = {
			"name" : name,
			"id" : id,
			"score" : 0
		}
	if multiplayer.is_server():
		for i in FbGameManager.Players:
			SendPlayerInformation.rpc(FbGameManager.Players[i].name, i)

func _on_host_button_down() -> void:
	peer = WebSocketMultiplayerPeer.new()
	var error
	error = peer.create_server(PORT, "*")
	if(error!=OK):
		print("Cannot host " + str(error))
		return
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players")
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	

func _on_join_button_down() -> void:
	peer = WebSocketMultiplayerPeer.new()
	var address = ""
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	peer.create_client("ws://" + address + ":" + str(PORT))
	multiplayer.set_multiplayer_peer(peer)


func _on_start_game_button_down() -> void: 
	StartGame.rpc()
