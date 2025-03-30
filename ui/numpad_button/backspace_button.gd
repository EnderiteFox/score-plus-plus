extends NumpadButton

func _on_pressed() -> void:
	player_edit_line.text = player_edit_line.text.substr(0, player_edit_line.text.length() - 1)
