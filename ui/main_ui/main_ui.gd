class_name MainUI
extends Control

@onready var add_player_button: Button = %AddPlayerButton
@onready var player_list: Control = %PlayerList

@onready var player_edit_panel: Control = %PlayerEditPanel
@onready var player_edit_line: LineEdit = %PlayerEditLine
@onready var player_edit_buttons: Node = %EditActionButtons

var player_ui_scene: PackedScene = preload("res://ui/player_ui/player_ui.tscn")

var selected_player: PlayerUI = null

func _ready() -> void:
	add_player_button.pressed.connect(_on_add_player)
	player_edit_panel.visible = false
	
	for button in player_edit_buttons.get_children():
		if button is EditActionButton:
			button.edit_action_pressed.connect(_apply_edit_action)
			
	player_edit_line.text_submitted.connect(_on_edit_line_submit.unbind(1))
	
	
func _on_add_player() -> void:
	var player_ui: PlayerUI = player_ui_scene.instantiate()
	player_list.add_child(player_ui)
	
	player_ui.selected.connect(_on_player_select.bind(player_ui))
	player_ui.selected.emit()
	
	player_ui.deleted.connect(_on_player_delete.bind(player_ui))

	
func _on_player_select(player_ui: PlayerUI) -> void:
	if selected_player == player_ui:
		return
	
	if selected_player != null:
		selected_player.unselect()
	
	player_ui.select()
	selected_player = player_ui
	player_edit_panel.visible = true
	player_edit_line.text = ""
	

func _on_player_delete(player_ui: PlayerUI) -> void:
	if selected_player == player_ui:
		player_ui.unselect()
		selected_player = null
		player_edit_panel.visible = false
		player_edit_line.text = ""
	

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and selected_player != null:
			selected_player.unselect()
			selected_player = null
			player_edit_panel.visible = false
			player_edit_line.text = ""
			
			
func _apply_edit_action(action_callable: Callable) -> void:
	if selected_player == null:
		# TODO: Handle error when no player is selected somehow
		return
	
	var expression := Expression.new()
	var error: Error = expression.parse(player_edit_line.text)
	
	if error != OK:
		# TODO: Handle error
		push_error(expression.get_error_text())
		return
		
	var value = expression.execute()
	
	if expression.has_execute_failed():
		# TODO: Handle error
		return
	
	action_callable.call(selected_player, value)
	
	player_edit_line.text = ""
	

func _on_edit_line_submit() -> void:
	if selected_player == null:
		return
		
	_apply_edit_action(
		func set_action(player_ui: PlayerUI, value: float):
			player_ui.score = value
	)
	
