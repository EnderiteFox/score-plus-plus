class_name MainUI
extends Control

@onready var add_player_button: Button = %AddPlayerButton
@onready var player_list: Control = %PlayerList
@onready var player_edit_panel: Control = %PlayerEditPanel

var player_ui_scene: PackedScene = preload("res://ui/player_ui/player_ui.tscn")

var selected_player: PlayerUI = null

func _ready() -> void:
	add_player_button.pressed.connect(_on_add_player)
	player_edit_panel.visible = false
	
	
func _on_add_player() -> void:
	var player_ui: PlayerUI = player_ui_scene.instantiate()
	player_list.add_child(player_ui)
	
	player_ui.selected.connect(_on_player_select.bind(player_ui))
	player_ui.selected.emit()
	
	player_ui.deleted.connect(_on_player_delete.bind(player_ui))

	
func _on_player_select(player_ui: PlayerUI) -> void:
	if selected_player != null:
		selected_player.unselect()
	
	player_ui.select()
	selected_player = player_ui
	player_edit_panel.visible = true
	

func _on_player_delete(player_ui: PlayerUI) -> void:
	if selected_player == player_ui:
		player_ui.unselect()
		selected_player = null
		player_edit_panel.visible = false
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and selected_player != null:
			selected_player.unselect()
			selected_player = null
			player_edit_panel.visible = false
