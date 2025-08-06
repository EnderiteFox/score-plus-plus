class_name AlertPopup
extends Node

@onready var dismiss_button: Button = %DismissButton
@onready var message_label: Label = %MessageLabel


func _ready() -> void:
	dismiss_button.pressed.connect(self.queue_free)
	
	
func set_message(message: String) -> void:
	message_label.text = message
