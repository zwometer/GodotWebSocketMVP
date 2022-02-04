extends Node

const DEFAULT_SERVER_URL = "localhost"
const DEFAULT_PORT = 9009
const PROTOCOL_NAME = "KTST"


onready var _main_menu = $MainMenu


var websocket_server = null
var is_connected_to_server : bool = false


func _ready():
	pass # Replace with function body.


func _on_ConnectBtn_pressed():
	_set_up_network()


func _on_DisconnectBtn_pressed():
	_close_network()
	websocket_server = null


func _set_up_network():
	if not is_connected_to_server:
		_reset_network()
		websocket_server = WebSocketClient.new()
		var connection_error = websocket_server.connect_to_url("ws://" + DEFAULT_SERVER_URL + ":" + str(DEFAULT_PORT), PoolStringArray([PROTOCOL_NAME]), true)
		var was_connection_failed_signal_connected = get_tree().connect("connection_failed", self, "_close_network")
		var was_connected_to_server_signal_connected = get_tree().connect("connected_to_server", self, "_connected")
		var was_disconnected_from_server_signal_connected = get_tree().connect("server_disconnected", self, "_close_network")
		if(connection_error == 0 and was_connection_failed_signal_connected == 0 and was_connected_to_server_signal_connected == 0 and was_disconnected_from_server_signal_connected == 0):
			get_tree().set_network_peer(websocket_server)
			print("Connection was set up successfully. Waiting for the server. If this takes more than a few seconds, something's fucky.")
		else:
			print("Connection setup failed")
	else:
		print("Your connection is already set up")


func _reset_network():
	if get_tree().is_connected("server_disconnected", self, "_close_network"):
		get_tree().disconnect("server_disconnected", self, "_close_network")
	if get_tree().is_connected("connection_failed", self, "_close_network"):
		get_tree().disconnect("connection_failed", self, "_close_network")
	if get_tree().is_connected("connected_to_server", self, "_connected"):
		get_tree().disconnect("connected_to_server", self, "_connected")
	get_tree().set_network_peer(null)
	is_connected_to_server = false
	_main_menu.update_connect_buttons(is_connected_to_server)


func _close_network():
	_reset_network()
	print("Network connection terminated")


func _connected():
	is_connected_to_server = true
	_main_menu.update_connect_buttons(is_connected_to_server)
	print("Connected successfully")



