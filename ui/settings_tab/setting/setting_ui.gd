class_name SettingUI
extends PanelContainer

@export var setting_name: StringName


func _ready() -> void:
	Main.settings_ready.connect(_on_settings_ready)
	
	
func _on_settings_ready() -> void:
	Main.settings.setting_changed.connect(_on_setting_changed)
		
		
func _on_setting_changed(_changed_setting_name: StringName, _value: Variant) -> void:
	pass
