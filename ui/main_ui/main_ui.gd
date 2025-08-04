class_name MainUI
extends Control

@onready var color_background: ColorRect = %ColorBackground
@onready var texture_background: TextureRect = %TextureBackground


func _ready() -> void:
	Main.main_ui = self
	
	
func set_background_color(color: Color) -> void:
	texture_background.visible = false
	color_background.visible = true
	color_background.color = color
	
	
func set_background_image(image_texture: Texture2D) -> void:
	texture_background.visible = true
	color_background.visible = false
	texture_background.texture = image_texture
