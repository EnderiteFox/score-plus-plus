extends Node

var main_ui: MainUI = null: set = _set_main_ui
var score: ScoreTab
var history: HistoryTab
var settings: SettingsTab: set = _set_settings

signal player_added(player: Player)
@warning_ignore("unused_signal")
signal player_modified(player: Player)
signal player_removed(player: Player)

signal settings_ready
signal main_ui_ready

var players: Array[Player]

var alert_popup_scene: PackedScene = preload("uid://dh8m1yy1ho1ed")


func _ready() -> void:
	OS.request_permission("android.permission.READ_EXTERNAL_STORAGE")
	OS.request_permission("android.permission.READ_MEDIA_IMAGES")
	OS.request_permission("android.permission.READ_MEDIA_VISUAL_USER_SELECTED")


func _set_settings(settings_tab: SettingsTab) -> void:
	settings = settings_tab
	settings_ready.emit()
	
	
func _set_main_ui(ui: MainUI) -> void:
	main_ui = ui
	main_ui_ready.emit()


func add_player() -> Player:
	var player := Player.new()
	players.append(player)
	player_added.emit(player)
	return player
	
	
func load_player(player: Player) -> void:
	players.append(player)
	player_added.emit(player)
	player_modified.emit(player)
	

func remove_player(player: Player) -> void:
	player_removed.emit(player)
	players.erase(player)


func push_alert(message: String) -> void:
	var alert_popup: AlertPopup = alert_popup_scene.instantiate()
	self.add_sibling.call_deferred(alert_popup)
	await alert_popup.ready
	alert_popup.set_message(message)
	print("Alert popup:\n", message)
