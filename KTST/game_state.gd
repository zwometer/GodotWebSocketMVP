extends Node

var _players : Dictionary = {}


remote func sync_game_state(players : Dictionary):
	_players = players
	print("Game state synced:")
	print("Currently connected Players: " + String(_players))
