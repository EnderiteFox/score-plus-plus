class_name SettingsColor
extends SettingUI

var color: Color = Color.WHITE: set = _set_color

@onready var color_picker_button: ColorPickerButton = %ColorPickerButton


func _ready() -> void:
	super._ready()
	var picker: ColorPicker = color_picker_button.get_picker()
	picker.edit_alpha = false
	picker.can_add_swatches = false
	picker.sampler_visible = false
	picker.color_modes_visible = false
	picker.sliders_visible = false
	picker.hex_visible = false
	picker.presets_visible = false
	
	color_picker_button.color_changed.connect(_on_color_changed)


func _on_setting_changed(changed_setting_name: StringName, new_value: Variant) -> void:
	if changed_setting_name == self.setting_name and new_value is Color:
		color = new_value
		
		
func _set_color(new_color: Color) -> void:
	color = new_color
	color_picker_button.color = new_color
	
	
func _on_color_changed(new_color: Color) -> void:
	Main.settings.set(setting_name, new_color)
