@tool
class_name SettingsCheckbox
extends PanelContainer

@onready var setting_title_label: Label = %SettingTitle
@onready var setting_description_label: Label = %SettingDescription
@onready var check_button: CheckButton = %CheckButton

@export var setting_title: String = "Setting Title": set = _on_set_setting_title
@export_multiline var setting_description: String = "Description for a setting that doesn't exist": 
	set = _on_set_setting_description
@export var setting_name: StringName

var pressed: bool = false: set = _on_set_pressed


func _ready() -> void:
	setting_title_label.text = setting_title
	setting_description_label.text = setting_description
	self.gui_input.connect(_on_gui_input)
	
	
func _on_gui_input(input_event: InputEvent) -> void:
	if input_event is InputEventMouseButton:
		if input_event.pressed:
			Main.settings.set(setting_name, not Main.settings.get(setting_name))


func _on_set_setting_title(new_title: String) -> void:
	setting_title = new_title
	if Engine.is_editor_hint() and setting_title_label != null:
		setting_title_label.text = new_title
	
	
func _on_set_setting_description(new_desc: String) -> void:
	setting_description = new_desc
	if Engine.is_editor_hint() and setting_description_label != null:
		setting_description_label.text = new_desc


func _on_set_pressed(new_pressed: bool) -> void:
	pressed = new_pressed
	check_button.button_pressed = new_pressed
	
