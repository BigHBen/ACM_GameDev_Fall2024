extends Node2D


var bet_amount = 0 : set = _set_bet, get = _get_bet

#Extras
var coin_scene = preload("res://Scenes/bet_stack_coin.tscn")  # replace with your coin scene path
var spawn_position = Vector2(830, 380)  # adjust initial spawn position
var spawned_coins = []
var coin_limit = 10
@onready var audio_player = $AudioStreamPlayer2D
@onready var minigame_manager = get_node("/root/MinigameManager")

#Reminder Panel
@onready var reminder_panel = $UI/ReminderPopup

#Horse Choices
var horse_count = randi() % 7 + 4
var horse_names = []
var horse_name_endings = [
	"Star", "Lightning", "Thunder", "Comet", "Spirit", 
	"Gallop", "Dash", "Blaze", "Storm", "Raven", 
	"Falcon", "Nova", "Zephyr", "Ranger", "Cannon",
	"Champion", "Vagabond", "Liberty", "Jasper", 
	"Dakota", "Pistol", "Cinnamon", "Flynn", "Cobalt", 
	"Onyx", "Brady", "Rowan", "Titan"
]
@onready var drop_down = $UI/MenuPanel/HorseChoicesPanel/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup():
	for i in range(horse_count):
		var random_name = horse_name_endings.pick_random()
		
		horse_names.append("Horse " + random_name)
		horse_name_endings.erase(random_name)
	drop_down.clear()
	drop_down.add_item(" ")
	for horse_name in horse_names:
		drop_down.add_item(horse_name)
		minigame_manager.set_horse_names(horse_names)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _set_bet(new_amount):
	bet_amount = new_amount
	#Access Singleton variable
	minigame_manager.set_horse_bet_amount(bet_amount)

func _get_bet():
	return bet_amount

func _on_horse_game_exit_pressed() -> void:
	get_tree().quit()

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


func _on_check_box_pressed():
	if spawned_coins.size() < coin_limit:
		spawn_coin(5)
		audio_player.play(0.3)
		bet_amount+=5

func _on_ten_dollar_bet_pressed():
	if spawned_coins.size() < coin_limit:
		spawn_coin(10)
		audio_player.play(0.3)
		bet_amount+=10

func _on_twenty_five_dollar_bet_pressed():
	if spawned_coins.size() < coin_limit:
		spawn_coin(25)
		audio_player.play(0.3)
		bet_amount+=25

#If horse is chosen
func _on_option_button_item_selected(index: int) -> void:
	if index != 0:
		minigame_manager.set_horse_bet(horse_names[index-1])

#Start game
func _on_horse_minigame_started() -> void:
	var dict = minigame_manager.get_horse_bet_info()
	var has_values1 = dict.has("horse") and len(dict["horse"]) > 0
	var has_values2 = dict.has("amount") and dict["amount"] > 0

	if has_values1 and has_values2:
		get_tree().change_scene_to_file("res://Scenes/horse_race.tscn")
	else:
		reminder_panel.visible = true
		reminder_panel.set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.2))
		await get_tree().create_timer(1).timeout
		print("Cannot start without horse choice")
		print("Pick a horse and bet coward")
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
