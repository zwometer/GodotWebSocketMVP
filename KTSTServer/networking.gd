extends Node

const DEFAULT_PORT = 9009
const PROTOCOL_NAME = "KTST"


onready var _game_state = $GameState


var websocket_server = null


func _ready():
	var was_disconnect_signal_connected = get_tree().connect(
		"network_peer_disconnected", self, "_peer_disconnected")
	var was_connect_signal_connected = get_tree().connect(
		"network_peer_connected", self, "_peer_connected")
	if(was_disconnect_signal_connected == 0 && was_connect_signal_connected == 0):
		print("Connection signals set up properly.")
	_start_hosting()


func _start_hosting():
	websocket_server = WebSocketServer.new()
	websocket_server.listen(DEFAULT_PORT, PoolStringArray([PROTOCOL_NAME]), true)
	get_tree().set_network_peer(websocket_server)


func _peer_connected(id):
	_game_state.on_add_network_player(id)


func _peer_disconnected(id):
	_game_state.on_remove_network_player(id)
