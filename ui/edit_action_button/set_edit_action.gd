extends EditActionButton

func _action(player_ui: PlayerUI, value: float) -> void:
	player_ui.score = value
