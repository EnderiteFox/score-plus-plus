class_name SettingsCheckbox
extends SettingUI

@onready var check_button: CheckButton = %CheckButton

var pressed: bool = false: set = _on_set_pressed

func _ready() -> void:
	super._ready()
	self.gui_input.connect(_on_gui_input)
	
	
func _on_setting_changed(changed_setting_name: StringName, value: Variant) -> void:
	if changed_setting_name == self.setting_name and value is bool:
		pressed = value
	
	
func _on_gui_input(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton:
		if input_event.pressed:
			Main.settings.set(setting_name, not Main.settings.get(setting_name))


func _on_set_pressed(new_pressed: bool) -> void:
	pressed = new_pressed
	check_button.button_pressed = new_pressed
