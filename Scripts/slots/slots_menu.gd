extends Node2D

var bet_amount = 0 : set = _set_bet, get = _get_bet
var casino ="res://Scenes/casino.tscn"
var scenes = ["res://Scenes/slot/slots_game.tscn",
			  "res://Scenes/Slots_Hacking_Scene_1.tscn"]
var coin_scene = preload("res://Scenes/bet_stack_coin.tscn")  # replace with your coin scene path
var spawn_position = Vector2(830, 380)  # adjust initial spawn position
var spawned_coins = []
var coin_limit = 10
@onready var audio_player = $AudioStreamPlayer2D
@onready var minigame_manager = get_node("/root/MinigameManager")

#Reminder Panel
@onready var reminder_panel = $UI/ReminderPopup

#signal get_Bet(bet)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _set_bet(new_amount):
	bet_amount = new_amount
	minigame_manager.set_slots_bet_amount(bet_amount)

func _get_bet():
	return bet_amount

func _on_slots_game_exit_pressed() -> void:
	get_tree().change_scene_to_file(casino)

func spawn_coin(type):
	var coin_instance = coin_scene.instantiate()
	coin_instance.position = spawn_position
	match type:
		5:
			coin_instance.frame = 1
		10:
			coin_instance.frame = 2
		25:
			coin_instance.frame = 3
	add_child(coin_instance)
	spawned_coins.append(coin_instance)
	spawn_position.y -= 10  # adjust spacing between coins


func _on_5_dolar_pressed() -> void:
	if spawned_coins.size() < coin_limit:
		spawn_coin(5)
		audio_player.play(0.3)
		bet_amount+=5


func _on_10_dollar_bet_pressed() -> void:
	if spawned_coins.size() < coin_limit:
		spawn_coin(10)
		audio_player.play(0.3)
		bet_amount+=10


func _on_25_dollar_bet_pressed() -> void:
	if spawned_coins.size() < coin_limit:
		spawn_coin(25)
		audio_player.play(0.3)
		bet_amount+=25

func _on_slots_game_start_pressed() -> void:
	
	var dict = minigame_manager.get_slots_bet_info()
	var has_values1 = dict.has("amount") and dict["amount"] > 0
	
	if has_values1:
		var sceneChange = randi_range(0,99)
		if(sceneChange < 80):
			get_tree().change_scene_to_file(scenes[0])
		else:
			get_tree().change_scene_to_file(scenes[1])
	else:
		reminder_panel.set_text("Cannot start without a bet!")
		reminder_panel.visible = true
		reminder_panel.set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.2))
		await get_tree().create_timer(0.5).timeout
		print("Cannot start without a bet")
		reminder_panel.visible = false

func _on_bet_remove_button_down() -> void:
	if !spawned_coins.is_empty():
		var instance = spawned_coins.back()
		if instance: 
			match instance.frame:
				1: bet_amount-= 5
				2: bet_amount-= 10
				3: bet_amount-= 25
			spawned_coins.erase(spawned_coins.back())
			spawn_position.y += 10
			instance.queue_free()
