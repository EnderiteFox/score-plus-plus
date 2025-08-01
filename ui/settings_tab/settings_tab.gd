class_name SettingsTab
extends Control

const save_path: String = "user://settings.ini"

@export var integer_score_checkbox: SettingsCheckbox
@export var persistent_players_checkbox: SettingsCheckbox
# TODO: Implement persistent players
@export var normalized_history_checkbox: SettingsCheckbox
# TODO: Implement score history
# TODO: Implement normalized history

var integer_score: bool: set = _on_set_integer_score

var persistent_players: bool:
	set(new_val):
		persistent_players = new_val
		if persistent_players_checkbox and persistent_players_checkbox.pressed != new_val:
			persistent_players_checkbox.pressed = new_val

var normalized_history: bool:
	set(new_val):
		normalized_history = new_val
		if persistent_players_checkbox and normalized_history_checkbox.pressed != new_val:
			normalized_history_checkbox.pressed = new_val

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
	if integer_score_checkbox.pressed != new_val:
		integer_score_checkbox.pressed = new_val
		
	if new_val:
		for player_ui in Main.score.player_list.get_children():
			if player_ui is PlayerUI:
				player_ui.score = int(player_ui.score)
				
	Main.score.numpad_dot_button.visible = not new_val


func save_settings() -> void:
	# If integer scores are enabled, round player scores
	if integer_score:
		for player_ui in Main.score.player_list.get_children():
			player_ui.score = int(player_ui.score)
	
	var config_file := ConfigFile.new()
	
	config_file.set_value("Settings", "integer_score", integer_score)
	config_file.set_value("Settings", "persistent_players", persistent_players)
	config_file.set_value("Settings", "normalized_history", normalized_history)
	
	if persistent_players:
		var players: Dictionary[String, float] = {}
		for player_ui in Main.score.player_list.get_children():
			if player_ui is PlayerUI:
				players[player_ui.player_name.text] = float(int(player_ui.score)) if integer_score else float(player_ui.score)
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
	persistent_players = config_file.get_value("Settings", "persistent_players", false)
	normalized_history = config_file.get_value("Settings", "normalized_history", true)
	
	if persistent_players:
		var player_scores: Dictionary[String, float] = config_file.get_value("Players", "players", {})
		for player_name in player_scores:
			Main.score.add_player(player_name, player_scores[player_name])
	
	
func apply_settings() -> void:
	save_settings()
