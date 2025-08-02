class_name VkeyboardResizer
extends Control


func _process(_delta: float) -> void:
	var keyboard_size: int = DisplayServer.virtual_keyboard_get_height() if DisplayServer.has_feature(DisplayServer.FEATURE_VIRTUAL_KEYBOARD) else 0
	self.custom_minimum_size.y = keyboard_size / get_viewport_transform().get_scale().y
