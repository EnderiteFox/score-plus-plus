class_name Player
extends Resource

var name: String = "": set = _set_name
var score: float = 0.0: set = _set_score


func _init(p_name: String = "", p_score: float = 0.0) -> void:
	name = p_name
	score = p_score


func _set_name(new_name: String) -> void:
	name = new_name
	Main.player_modified.emit(self)


func _set_score(new_score: float) -> void:
	if Main.settings.integer_score:
		score = int(new_score)
	else:
		score = new_score
	Main.player_modified.emit(self)
