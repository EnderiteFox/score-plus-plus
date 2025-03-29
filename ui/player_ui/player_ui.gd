class_name PlayerUI
extends PanelContainer

signal selected
signal deleted

@onready var delete_button: Button = %DeleteButton

func _ready() -> void:
	delete_button.pressed.connect(_on_player_delete)

	
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
			
