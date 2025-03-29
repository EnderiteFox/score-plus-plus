class_name NumpadButton
extends Button

@export var player_edit_line: LineEdit

func _ready() -> void:
	self.pressed.connect(_on_pressed)
	
	
func _on_pressed() -> void:
	player_edit_line.text += self.text
