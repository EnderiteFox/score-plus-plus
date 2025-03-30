class_name PlayerUI
extends PanelContainer

signal selected
signal deleted

@onready var delete_button: Button = %DeleteButton
@onready var player_name: LineEdit = %PlayerName

func _ready() -> void:
	delete_button.pressed.connect(_on_player_delete)
	player_name.focus_entered.connect(selected.emit)
	player_name.text_changed.connect(selected.emit.unbind(1))

	
func _on_player_delete() -> void:
	deleted.emit()
	self.queue_free()
	
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected.emit()
			
			
func select() -> void:
	self.theme_type_variation = "Selected"
	
	
func unselect() -> void:
	self.theme_type_variation = ""
	player_name.focus_mode = FOCUS_NONE
			
