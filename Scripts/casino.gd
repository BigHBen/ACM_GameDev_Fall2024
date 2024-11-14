extends Node2D

#Dictionary w minigame scene paths
var minigames =  {
	horse_minigame = "res://Scenes/horse/horse_race_menu.tscn", #Minigame select scene
	slots_minigame = "res://Scenes/slot/slots_menu.tscn",
	chicken_minigame = "res://Scenes/chicken_fight/chicken_punching.tscn",
	hub = "res://Scenes/hub.tscn"
	}

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
	background_music.volume_db = -25.0
	backgronud_crowd.volume_db = -25.0
	background_music.play(46)
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
