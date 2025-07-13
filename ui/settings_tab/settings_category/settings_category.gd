@tool
class_name SettingsCategory
extends PanelContainer

@onready var title_label: Label = %CategoryTitle

@export var title: String = "Section": set = _on_title_set


func _ready() -> void:
	title_label.text = title


func _on_title_set(new_title: String) -> void:
	title = new_title
	if Engine.is_editor_hint() and title_label != null:
		title_label.text = new_title
