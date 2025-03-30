class_name EditActionButton
extends Button

signal edit_action_pressed(action: Callable)

func _ready() -> void:
	self.pressed.connect(edit_action_pressed.emit.bind(_action))

func _action(_player_ui: PlayerUI, _value: float) -> void:
	push_error("The _action method should be redefined!")
