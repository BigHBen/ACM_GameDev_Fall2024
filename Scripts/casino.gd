extends Node2D

#Dictionary w minigame scene paths
var minigames =  {
	horse_minigame = "res://Scenes/horse/horse_race_menu.tscn", #Minigame select scene
	slots_minigame = "res://Scenes/slot/slots_menu.tscn",
	chicken_minigame = "res://Scenes/chicken_fight/chicken_punching.tscn",
	hub = "res://Scenes/hub.tscn"
	}
#currency
@onready var Currency_Manager = get_node("/root/CurrencyManager")

@export var double_money = 20 # Extra money to give player
#Timer
@onready var casino_timer = get_node("/root/CasinoTimer")
@onready var minigame_manager = get_node("/root/MinigameManager")

#UI Variables
@onready var winning_bets_label = $UI/Earnings

#Audio variables
@onready var background_music = $Audio/Background/casino_jazz
@onready var backgronud_crowd = $Audio/Background/crowd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(casino_timer.time_left)
	background_music.volume_db = -25.0
	backgronud_crowd.volume_db = -25.0
	background_music.play(46)
	_get_powerups()
	print("\nWelcome to the Casino!")
	print("You've played %d minigames" % minigame_manager.minigame_count)
	if minigame_manager.minigame_count > 0:
		winning_bets_label.text = "Earnings: $%d" % [minigame_manager.get_winning_bet()]
		print("Money earned from minigames: $%d" % [minigame_manager.get_winning_bet()])
	else: 
		winning_bets_label.text = "Earnings: $%d" % 0
		minigame_manager.set_winning_bet(0)

func _process(_delta: float) -> void:
	pass

#region MinigameSelection
func _on_horse_minigame_pressed() -> void:
	#Go to horse racing menu
	get_tree().change_scene_to_file(minigames["horse_minigame"])

func _on_slots_minigame_pressed() -> void:
	get_tree().change_scene_to_file(minigames["slots_minigame"])

func _on_chicken_minigame_pressed() -> void:
	get_tree().change_scene_to_file(minigames["chicken_minigame"])
#endregion

func _on_exit_pressed() -> void:
	get_tree().quit()

func _get_powerups():
	if (MinigameManager.get_powerup("Double_Time") != null && MinigameManager.get_powerup("Double_Time")[1] == true ):
		MinigameManager.get_powerup("Double_Time")[1] = false
		casino_timer.set_game_time(casino_timer.get_game_time() * 2)
		$UI/Panel4/Label.text = "You Have activated Double Time"
		$UI/Panel4.visible = true
		await get_tree().create_timer(1).timeout
		$UI/Panel4.visible = false
	if(MinigameManager.get_powerup("Double_Money") != null && MinigameManager.get_powerup("Double_Money")[1] == true):
		MinigameManager.get_powerup("Double_Money")[1] = false
		if(Currency_Manager.get_balance() == 0):
			print("You Have Double Money (U have 0 dolar)!" ," you've earned: ",str(minigame_manager.winning_bet + double_money))
			#minigame_manager.set_winning_bet((minigame_manager.winning_bet + double_money))
			Currency_Manager.set_balance(minigame_manager.get_winning_bet() + 50)
			$UI/Panel4/Label.text = "You Have activated gotten $20"
		else:
			var bal = Currency_Manager.get_balance() 
			print("You Have Double Money!" ," you've earned: ",str(minigame_manager.winning_bet * 2))
			#minigame_manager.set_winning_bet(minigame_manager.winning_bet * 2)
			Currency_Manager.set_balance(minigame_manager.get_winning_bet() + (bal * 2))
			$UI/Panel4/Label.text = "You Have activated gotten double money"
		$UI/Panel4.visible = true
		await get_tree().create_timer(1).timeout
		$UI/Panel4.visible = false
