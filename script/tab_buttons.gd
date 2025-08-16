class_name TabButtons
extends Control

const THEME_VAR_TAB_BUTTON: StringName = &"TabButton"
const THEME_VAR_TAB_BUTTON_SELECTED: StringName = &"TabButtonSelected"


@export var buttons: Dictionary[Button, Control]


func _ready() -> void:
	for button in buttons:
		button.pressed.connect(_on_tab_button_pressed.bind(button, buttons[button]))


func _on_tab_button_pressed(button: Button, pressed_tab: Control) -> void:
	for all_button in buttons:
		buttons[all_button].visible = false
		all_button.theme_type_variation = THEME_VAR_TAB_BUTTON
	pressed_tab.visible = true
	button.theme_type_variation = THEME_VAR_TAB_BUTTON_SELECTED
