extends Node

var score: ScoreTab
var history: HistoryTab
var settings: SettingsTab: set = _set_settings

signal player_added(player: Player)
@warning_ignore("unused_signal")
signal player_modified(player: Player)
signal player_removed(player: Player)

signal settings_ready

var players: Array[Player]


func _set_settings(settings_tab: SettingsTab) -> void:
	settings = settings_tab
	settings_ready.emit()


func add_player() -> Player:
	var player := Player.new()
	players.append(player)
	player_added.emit(player)
	return player
	

func remove_player(player: Player) -> void:
	player_removed.emit(player)
	players.erase(player)
