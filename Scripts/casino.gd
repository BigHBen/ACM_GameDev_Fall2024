extends Node2D


#Dictionary w minigame scene paths
var minigames =  {
	horse_minigame = "res://Scenes/horse/horse_race_menu.tscn", #Minigame select scene
	slots_minigame = "res://Scenes/slot/slots_menu.tscn",
	chicken_minigame = "res://Scenes/chicken_fight/chicken_punching.tscn",
	hub = "res://Scenes/hub.tscn"
	}

#Timer
@onready var timer_bar = get_node("/root/TimerBar")
@onready var casino_timer = get_node("/root/CasinoTimer")
@onready var minigame_manager = get_node("/root/MinigameManager")

#Audio variables
@onready var background_music = $Audio/Background/casino_jazz
@onready var backgronud_crowd = $Audio/Background/crowd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.volume_db = -25.0
	backgronud_crowd.volume_db = -25.0
	background_music.play(46)
	print("Money earned from minigames: $%s" % [minigame_manager.get_winning_bet()])



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if casino_timer.is_stopped():
		get_tree().change_scene_to_file(minigames["hub"])


func _on_horse_minigame_pressed() -> void:
	#Go to horse racing menu
	get_tree().change_scene_to_file(minigames["horse_minigame"])

func _on_slots_minigame_pressed() -> void:
	get_tree().change_scene_to_file(minigames["slots_minigame"])

func _on_chicken_minigame_pressed() -> void:
	get_tree().change_scene_to_file(minigames["chicken_minigame"])

func _on_exit_pressed() -> void:
	get_tree().quit()
