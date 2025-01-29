extends Control

# Menu Sprites and Audio
@onready var background = $background
@onready var sprite = self
@onready var background_audio = $Audio/background_music

# Settings
@onready var options_button = $settings/settings_panel/VBoxContainer/WindowSIZE/OptionButton as OptionButton

#Extras
@onready var button_coin = $Extras/button_coin

func _ready():
	
	# Close settings panel when starting game
	setup_settings($settings)
	
	# Load main menu panel (with style)
	fade_in(sprite,1.0)
	
	for button in $MenuButtons.get_children():
		if button is Button:
			button.mouse_exited.connect(on_menu_button_left)
	
	# Start background music
	play_background_music()


func fade_in(s,sec:float):
	self.modulate = Color(0, 0, 0, 1)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(s, "modulate", Color(1, 1, 1, 1), sec)

func fade_out(s,sec:float):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(s, "modulate", Color(0, 0, 0, 1), sec)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/hub.tscn")

func move_out_of_frame(s,dist : float):
	var tween = create_tween()
	var target_position = Vector2(-background.texture.get_width()/dist, sprite.position.y)  # Move completely off the screen to the left
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(s, "position", target_position, 0.5)
	
	#fade_in($settings.get_child(0),0.25)
	open_settings($settings)
	await tween.finished
	

func move_into_frame(s):
	var tween = create_tween()
	var target_position = Vector2(0, sprite.position.y)  # Move completely off the screen to the left
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(s, "position", target_position, 0.5)

# Open and close settings
func setup_settings(cont):
	options_button.add_resolution_items()
	options_button.item_selected.connect(on_resolution_selected)
	cont.visible = false

func open_settings(cont):
	cont.visible = true

func close_settings(cont):
	cont.visible = false

# Audio - Start song at 5s
func play_background_music():
	background_audio.play(5.0)

# Main Menu - Button Signals
func _on_play_pressed() -> void:
	$MenuButtons/menu_animator.play("move_scene")
	$Audio/play_audio.play(0.3)
	fade_out(self,2.0)

func _on_settings_pressed() -> void:
	close_settings($settings)
	move_out_of_frame(self,1.7)

func _on_quit_pressed() -> void:
	get_tree().quit()

# Settings - Signals
func _on_full_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func on_resolution_selected(index: int) -> void:
	DisplayServer.window_set_size(options_button.RESOLUTION_DICT.values()[index])

func _on_back_button_pressed() -> void:
	move_into_frame(self)

# Extras - Animated Chip Sprite
func _on_play_mouse_entered() -> void:
	var button : Button = $MenuButtons/play
	var padding = 10
	var button_center_right = button.global_position + Vector2(button.size.x - 64 + padding, button.size.y / 2)
	
	# Set the sprite's position to the button's center
	button_coin.position = button_center_right

func _on_settings_mouse_entered() -> void:
	var button : Button = $MenuButtons/settings
	var padding = 10
	var button_center_right = button.global_position + Vector2(button.size.x - 64 + padding, button.size.y / 2)
	
	# Set the sprite's position to the button's center
	button_coin.position = button_center_right

func _on_quit_mouse_entered() -> void:
	var button : Button = $MenuButtons/quit
	var padding = 10
	var button_center_right = button.global_position + Vector2(button.size.x - 64 + padding, button.size.y / 2)
	
	# Set the sprite's position to the button's center
	button_coin.position = button_center_right

func on_menu_button_left() -> void:
	button_coin.position = Vector2(-32,-32)
