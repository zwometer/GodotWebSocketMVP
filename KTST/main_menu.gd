extends Control


onready var _connect_button = $ConnectBtn
onready var _disconnect_button = $DisconnectBtn


func update_connect_buttons(is_connected_to_server):
	_connect_button.disabled = is_connected_to_server
	_disconnect_button.disabled = !is_connected_to_server
