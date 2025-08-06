class_name PlayerUI
extends PanelContainer

var player: Player

@onready var delete_button: Button = %DeleteButton
@onready var player_name: LineEdit = %PlayerName
@onready var score_label: Label = %PlayerScore

func _ready() -> void:
	Main.player_removed.connect(_on_player_removed)
	Main.player_modified.connect(_on_player_modified)

	Main.score.player_selected.connect(_on_player_selected)
	Main.score.player_unselected.connect(_on_player_unselected)
	
	delete_button.pressed.connect(Main.remove_player.bind(self.player))
	player_name.focus_entered.connect(Main.score.player_selected.emit.bind(self.player))
	player_name.text_changed.connect(_on_text_changed)
	
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			Main.score.select_player(self.player)
	
	
func _on_player_removed(removed_player: Player) -> void:
	if removed_player == self.player:
		self.queue_free()
		
		
func _on_player_modified(modified_player: Player) -> void:
	if modified_player == self.player:
		update_infos()
	
	
func _on_player_selected(selected_player: Player) -> void:
	if selected_player == self.player:
		self.theme_type_variation = "Selected"
	
	
func _on_player_unselected(unselected_player: Player) -> void:
	if unselected_player == self.player:
		self.theme_type_variation = ""
		player_name.release_focus()
		
		
func _on_text_changed(new_text: String) -> void:
	Main.player_modified.disconnect(_on_player_modified)
	self.player.name = new_text
	Main.player_modified.connect(_on_player_modified)
	
	
func update_infos() -> void:
	player_name.text = player.name
	score_label.text = str(int(player.score)) if Main.settings.integer_score else str(player.score)
