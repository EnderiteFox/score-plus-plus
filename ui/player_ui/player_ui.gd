class_name PlayerUI
extends Node

@onready var delete_button: Button = %DeleteButton

func _ready() -> void:
	delete_button.pressed.connect(_on_player_delete)
	
	
func _on_player_delete() -> void:
	self.queue_free()
