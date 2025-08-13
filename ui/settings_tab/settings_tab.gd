class_name SettingsTab
extends Control

const save_path: String = "user://settings.ini"

const ROUND_COUNT_NONE: int = -1
const ROUND_COUNT_INFINITE: int = 0

const BACKGROUND_DEFAULT_COLOR := Color(0x333333FF)

signal setting_changed(setting_name: StringName, value: Variant)

enum BackgroundType {
	COLOR,
	IMAGE
}

@export var integer_score_checkbox: SettingsCheckbox
@export var persistent_players_checkbox: SettingsCheckbox
@export var round_count_int: SettingsInt
@export var normalized_history_checkbox: SettingsCheckbox
# TODO: Implement score history
# TODO: Implement normalized history

@onready var background_color_button: Button = %ColorBackgroundButton
@onready var background_image_button: Button = %ImageBackgroundButton
@onready var background_reset_button: Button = %ResetBackgroundButton
@onready var reset_scores_button: Button = %ResetScoresButton

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

var background_color: Color = BACKGROUND_DEFAULT_COLOR:
	set(new_val):
		background_color = new_val
		setting_changed.emit(&"background_color", new_val)

var current_background_type := BackgroundType.COLOR
var current_background_path: String: set = _on_set_background_path


func _ready() -> void:
	Main.settings = self
	background_color_button.pressed.connect(_on_background_color_pressed)
	background_image_button.pressed.connect(_on_background_image_pressed)
	background_reset_button.pressed.connect(_on_background_reset_pressed)
	reset_scores_button.pressed.connect(_on_reset_scores_pressed)
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
	
	
func _on_background_color_pressed() -> void:
	Main.main_ui.set_background_color(background_color)
	current_background_type = BackgroundType.COLOR
	
	
func _on_background_image_pressed() -> void:
	var error: Error = DisplayServer.file_dialog_show(
		"Select background image",
		"",
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		PackedStringArray(["*.png,*.jpg,*.jpeg", "Image Files", "image/png,image/jpeg"]),
		_on_background_image_selected
	)
	
	if error != OK:
		Main.push_alert("Error while selecting file:\n%s" % error_string(error))
		
		
func _on_background_image_selected(status: bool, selected_paths: PackedStringArray, selected_filter_index: int) -> void:
	if status:
		current_background_path = selected_paths[selected_filter_index]
	else:
		Main.push_alert("Error while selecting image.\nMake sure to allow file access permissions")
		
		
func _on_reset_scores_pressed() -> void:
	for player in Main.players:
		player.score = 0


func _on_set_background_path(path: String) -> void:
	current_background_path = path
	
	var image := Image.load_from_file(path)
	var texture := ImageTexture.create_from_image(image)
	
	if Main.main_ui == null:
		await Main.main_ui_ready
	Main.main_ui.set_background_image(texture)
	current_background_type = BackgroundType.IMAGE


func _on_background_reset_pressed() -> void:
	background_color = BACKGROUND_DEFAULT_COLOR
	Main.main_ui.set_background_color(BACKGROUND_DEFAULT_COLOR)
	current_background_type = BackgroundType.COLOR


func save_settings() -> void:
	var config_file := ConfigFile.new()
	
	config_file.set_value("Settings", "integer_score", integer_score)
	config_file.set_value("Settings", "persistent_players", persistent_players)
	config_file.set_value("Settings", "round_count", round_count)
	config_file.set_value("Settings", "normalized_history", normalized_history)
	config_file.set_value("Settings", "current_background_type", current_background_type)
	
	match current_background_type:
		BackgroundType.COLOR:
			config_file.set_value("Settings", "background_color", background_color)
		BackgroundType.IMAGE:
			config_file.set_value("Settings", "background_image_path", current_background_path)
	
	if persistent_players:
		var players: Dictionary[String, float] = {}
		for player in Main.players:
			players[player.name] = player.score
		config_file.set_value("Players", "players", players)
	
	var error: int = config_file.save(save_path)
	if error:
		Main.push_alert("An error occured while saving settings:\n%s" % error)
	
	
func load_settings() -> void:
	var config_file := ConfigFile.new()
	var error: int = config_file.load(save_path)

	match(error):
		Error.OK:
			pass
		Error.ERR_FILE_NOT_FOUND:
			# Not an error
			print("Settings file not found, using default values")
		_:
			Main.push_alert("An error occured while loading settings:\n%s" % error)
			return
		
	integer_score = config_file.get_value("Settings", "integer_score", true)
	persistent_players = config_file.get_value("Settings", "persistent_players", true)
	round_count = config_file.get_value("Settings", "round_count", ROUND_COUNT_INFINITE)
	normalized_history = config_file.get_value("Settings", "normalized_history", true)
	current_background_type = config_file.get_value("Settings", "current_background_type", BackgroundType.COLOR)
	
	match current_background_type:
		BackgroundType.COLOR:
			background_color = config_file.get_value("Settings", "background_color", BACKGROUND_DEFAULT_COLOR)
			Main.main_ui_ready.connect(func(): Main.main_ui.set_background_color(background_color))
		BackgroundType.IMAGE:
			current_background_path = config_file.get_value("Settings", "background_image_path", "")
	
	if persistent_players:
		var player_scores: Dictionary = config_file.get_value("Players", "players", {})
		for player_name in player_scores:
			var player: Player = Main.add_player()
			player.name = player_name	
			player.score = player_scores[player_name]
