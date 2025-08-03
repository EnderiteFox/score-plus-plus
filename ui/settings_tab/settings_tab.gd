class_name SettingsTab
extends Control

const save_path: String = "user://settings.ini"

const ROUND_COUNT_NONE: int = -1
const ROUND_COUNT_INFINITE: int = 0

signal setting_changed(setting_name: StringName, value: Variant)

@export var integer_score_checkbox: SettingsCheckbox
@export var persistent_players_checkbox: SettingsCheckbox
@export var round_count_int: SettingsInt
@export var normalized_history_checkbox: SettingsCheckbox
# TODO: Implement score history
# TODO: Implement normalized history

var integer_score: bool: set = _on_set_integer_score

var persistent_players: bool:
	set(new_val):
		persistent_players = new_val
		setting_changed.emit(&"persistent_players", new_val)

var round_count: int:
	set(new_val):
		round_count = new_val
		setting_changed.emit(&"round_count", new_val)

var normalized_history: bool:
	set(new_val):
		normalized_history = new_val
		setting_changed.emit(&"normalized_history", new_val)


func _ready() -> void:
	Main.settings = self
	load_settings()
	
	
func _notification(notif) -> void:
	if notif == NOTIFICATION_WM_CLOSE_REQUEST or notif == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_settings()
		get_tree().quit()
	elif notif == NOTIFICATION_APPLICATION_PAUSED:
		save_settings()
	
	
func _on_set_integer_score(new_val: bool) -> void:
	integer_score = new_val
	setting_changed.emit(&"integer_score", new_val)
		
	if new_val:
		for player in Main.players:
			player.score = player.score
				
	Main.score.numpad_dot_button.visible = not new_val


func save_settings() -> void:
	var config_file := ConfigFile.new()
	
	config_file.set_value("Settings", "integer_score", integer_score)
	config_file.set_value("Settings", "persistent_players", persistent_players)
	config_file.set_value("Settings", "round_count", round_count)
	config_file.set_value("Settings", "normalized_history", normalized_history)
	
	if persistent_players:
		var players: Dictionary[String, float] = {}
		for player in Main.players:
			players[player.name] = player.score
		config_file.set_value("Players", "players", players)
	
	var error: int = config_file.save(save_path)
	if error:
		push_error("An error occured while saving settings: ", error)
	
	
func load_settings() -> void:
	var config_file := ConfigFile.new()
	var error: int = config_file.load(save_path)

	match(error):
		Error.OK:
			pass
		Error.ERR_FILE_NOT_FOUND:
			print("Settings file not found, using default values")
		_:
			# TODO: Handle error correctly (add a popup)
			push_error("An error occured while loading settings: ", error)
			return
		
	integer_score = config_file.get_value("Settings", "integer_score", true)
	persistent_players = config_file.get_value("Settings", "persistent_players", true)
	round_count = config_file.get_value("Settings", "round_count", ROUND_COUNT_INFINITE)
	normalized_history = config_file.get_value("Settings", "normalized_history", true)
	
	if persistent_players:
		var player_scores: Dictionary[String, float] = config_file.get_value("Players", "players", {})
		for player_name in player_scores:
			var player: Player = Main.add_player()
			player.name = player_name	
			player.score = player_scores[player_name]
	
	
func apply_settings() -> void:
	save_settings()
