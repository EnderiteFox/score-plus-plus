class_name MainUI
extends Node

@onready var add_player_button: Button = %AddPlayerButton
@onready var player_list: Control = %PlayerList

var player_ui_scene: PackedScene = preload("res://ui/player_ui/player_ui.tscn")

func _ready() -> void:
	add_player_button.pressed.connect(_on_add_player)
	
	
func _on_add_player() -> void:
	player_list.add_child(player_ui_scene.instantiate())
