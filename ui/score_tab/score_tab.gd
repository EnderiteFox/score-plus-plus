class_name ScoreTab
extends Control

signal player_selected(player: Player)
signal player_unselected(player: Player)

@onready var add_player_button: Button = %AddPlayerButton
@onready var player_list: Control = %PlayerList

@onready var player_edit_panel: Control = %PlayerEditPanel
@onready var player_edit_line: LineEdit = %PlayerEditLine
@onready var player_edit_buttons: Node = %EditActionButtons
@onready var numpad_dot_button: Button = %NumpadDotButton

@onready var edit_buttons: Control = %EditButtons

@onready var add_button: Button = %AddButton
@onready var subtract_button: Button = %SubtractButton
@onready var set_button: Button = %SetButton

var player_ui_scene: PackedScene = preload("uid://diusqu2gxbitm")

var selected_player_ui: PlayerUI = null
var selected_player: Player = null

var player_uis: Dictionary[Player, PlayerUI]

func _ready() -> void:
	Main.score = self
	Main.player_removed.connect(_on_player_removed)
	Main.player_added.connect(_on_player_added)
	
	player_selected.connect(_on_player_selected)
	player_unselected.connect(_on_player_unselected)

	add_player_button.pressed.connect(Main.add_player)
	player_edit_panel.visible = false
			
	player_edit_line.text_submitted.connect(_on_edit_line_submit.unbind(1))
	
	add_button.pressed.connect(_on_add_button_pressed)
	subtract_button.pressed.connect(_on_subtract_button_pressed)
	set_button.pressed.connect(_on_set_button_pressed)
	
	player_edit_line.editing_toggled.connect(_on_line_edit_editing_toggled)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			unselect_player()
	
	
func _on_player_selected(player: Player) -> void:
	if not player_uis.has(player):
		push_error("Missing player key in player UI dict")
		return
		
	selected_player = player
	selected_player_ui = player_uis[player]

	player_edit_panel.visible = true
	player_edit_line.text = ""
	
	
func _on_player_unselected(_unselected_player: Player) -> void:
	selected_player = null
	selected_player_ui = null
	
	player_edit_panel.visible = false
	player_edit_line.text = ""
	
	
func _on_player_added(player: Player) -> void:
	var player_ui: PlayerUI = player_ui_scene.instantiate()
	player_ui.player = player
	player_list.add_child(player_ui)
	player_uis[player] = player_ui
	
	
func _on_player_removed(player: Player) -> void:
	if selected_player == player:
		player_unselected.emit(player)
		
	player_uis.erase(player)
	
	
func get_edit_line_value() -> float:
	if player_edit_line.text == "":
		return 0.0
	
	var expression := Expression.new()
	var error: Error = expression.parse(player_edit_line.text)
	
	if error != OK:
		# TODO: Handle error
		push_error(expression.get_error_text())
		return 0.0
		
	var value = expression.execute()
	
	if expression.has_execute_failed():
		# TODO: Handle error
		return 0.0
		
	player_edit_line.text = ""
	return value
	

func _on_edit_line_submit() -> void:
	if selected_player == null:
		return
		
	selected_player.score = get_edit_line_value()
	
	
func _on_add_button_pressed() -> void:
	if selected_player == null:
		return
		
	selected_player.score += get_edit_line_value()
	
	
func _on_subtract_button_pressed() -> void:
	if selected_player == null:
		return
	
	selected_player.score -= get_edit_line_value()
	
	
func _on_set_button_pressed() -> void:
	if selected_player == null:
		return
		
	selected_player.score = get_edit_line_value()
	
	
func _on_line_edit_editing_toggled(editing: bool) -> void:
	if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD):
		edit_buttons.visible = not editing
		
		
func unselect_player() -> void:
	if selected_player != null:
		# Keep reference to the unselected player to prevent it from becoming null
		var unselected_player: Player = selected_player
		player_unselected.emit(unselected_player)
		
		
func select_player(player: Player) -> void:
	unselect_player()
	player_selected.emit(player)
