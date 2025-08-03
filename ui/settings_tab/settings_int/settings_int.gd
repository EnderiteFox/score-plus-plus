class_name SettingsInt
extends SettingUI

@export var text_display_values: Dictionary[int, String]

@export var default_value: int = 0
@export var has_min_value: bool = true
@export var min_value: int = 0
@export var has_max_value: bool = false
@export var max_value: int = 0

@onready var int_line_edit: LineEdit = %IntLabel
@onready var add_button: Button = %AddButton
@onready var subtract_button: Button = %SubtractButton

@onready var value: int = default_value: set = _set_value

func _ready() -> void:
	super._ready()
	add_button.pressed.connect(_on_add_button_pressed)
	subtract_button.pressed.connect(_on_subtract_button_pressed)
	int_line_edit.text_submitted.connect(_on_int_submitted)
	value = default_value


func _on_setting_changed(changed_setting_name: StringName, new_value: Variant) -> void:
	if changed_setting_name == self.setting_name and new_value is int:
		value = new_value
	
	
func _set_value(new_value: int) -> void:
	value = new_value
	if text_display_values.has(new_value):
		int_line_edit.text = text_display_values[new_value]
	else:
		int_line_edit.text = str(new_value)
	
	
func _on_add_button_pressed() -> void:
	var new_value: int = Main.settings.get(setting_name) + 1
	if has_min_value and new_value < min_value:
		new_value = min_value
	if has_max_value and new_value > max_value:
		new_value = max_value
	Main.settings.set(setting_name, new_value)
	
	
func _on_subtract_button_pressed() -> void:
	var new_value: int = Main.settings.get(setting_name) - 1
	if has_min_value and new_value < min_value:
		new_value = min_value
	if has_max_value and new_value > max_value:
		new_value = max_value
	Main.settings.set(setting_name, new_value)
	
	
func _on_int_submitted(text: String) -> void:
	if text_display_values.values().has(text):
		Main.settings.set(setting_name, text_display_values.find_key(text))
		return
		
	if not text.is_valid_int():
		value = value
		return
		
	var new_value: int = int(text)
	if has_min_value and new_value < min_value:
		new_value = min_value
	if has_max_value and new_value > max_value:
		new_value = max_value
	Main.settings.set(setting_name, new_value)
