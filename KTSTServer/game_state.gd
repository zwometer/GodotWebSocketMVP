extends Node

var _players : Dictionary = {}


func on_add_network_player(id):
	_players[id] = "Playername" + String(id)
	print("Player connected. Their ID is: " + String(id))
	print("Currently connected Players: " + String(_players))
	rpc("sync_game_state", _players)


func on_remove_network_player(id):
	var was_player_removed = _players.erase(id)
	if not was_player_removed:
		print("something went wrong, trying to remove the player with the ID " + String(id))
	print("Player left. Their ID was: " + String(id))
	print("Currently connected Players: " + String(_players))
	
	# Can't just call rpc on every peer here, because the one that just disconnected is technically
	# still listed as connected, so rpc would try to call this on the disconnected peer.
	for id in _players.keys():
		rpc_id(id, "sync_game_state", _players)
