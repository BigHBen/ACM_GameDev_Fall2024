extends Node2D

var race_speed_scale = 3.0
@onready var start_timer = $Start_Timer
@onready var countdown_label = $UI/Label
@onready var return_label = $UI/WinPanel/HBoxContainer/Return

@onready var dirt_track = $CanvasLayer/ParallaxBackground/ParallaxLayer/dirt_track
@onready var race_timer = $RaceTimer
@onready var finish_timer = $FinishTimer

var start_position = Vector2(-300,260)
var race_started = false

@onready var minigame_manager = get_node("/root/MinigameManager")

#instance for finish line sprite
var finish_line

const finish_line_SCENE = preload("res://Scenes/horse/finish_line.tscn")  # Replace with your finish_line scene
const SPAWN_POSITION = Vector2(2396, 1260)  # Initial spawn position

#Horses

var your_bet #From minigame_manager
var horses_info #From minigame_manager

var horse_counter = 0
var horse_preload = preload("res://Scenes/horse/horse.tscn")
var horse = null
var horses = []
@export var num_horses = 5

#End conditions
var winners = []
var win = false #Correct bet
signal start_race()
signal end_race()

#Win Panel
@onready var win_panel = $UI/WinPanel
@onready var win_anim : AnimationPlayer = $UI/WinPanel/AnimationPlayer 
#Popup Effect Variables
var scale_amount = 0.5
var scale_speed = 0.25

var casino = "res://Scenes/casino.tscn" #Minigame select scene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	horses_info = minigame_manager.horse_names
	your_bet = minigame_manager.get_horse_bet_info()
	
	if horses_info.is_empty():
		num_horses = 5
		printerr("Minigame started without required variables")
	else: 
		num_horses = len(horses_info)
	spawn_horses()
	start_race.connect(on_race_started)
	end_race.connect(on_race_finished)
	start_timer.start()
	
	start_audio()
	
	#Set UI conditions
	win_panel.visible = false

func _process(_delta):
	if !start_timer.is_stopped():
		update_label()
	if finish_line:
		finish_line.position.x -= 20
	if !finish_timer.is_stopped():
		if winners.size() == 3:
			set_win_labels()
		update_return_label()

func spawn_horses():
	var total_height = 300
	var spacing = float(total_height) / (num_horses - 1)
	if num_horses > 1: 
		spacing = float(total_height) / (num_horses - 1)
	else: spacing = 75
	
	var horse_spawn = start_position
	for i in range(num_horses):
		if i != 0: horse_spawn.y += spacing 
		horse = horse_preload.instantiate()
		horse.position = horse_spawn
		if horses_info.is_empty():
			horse.name = "#" + str(i) + " Horse"
		else:
			horse.name = "#" + str(i) + " " + horses_info[i]
		horse_counter += 1
		horse.generate_positions()
		add_child(horse)

func start_audio():
	$Audio/start_trumpet.play(3.5)

func watch_for_winner():
	var dirt_track_parallax = $CanvasLayer/ParallaxBackground/ParallaxLayer
	var line_distance = finish_line.get_global_position() + dirt_track_parallax.motion_offset
	finish_line.position.x = line_distance.x

func update_label():
	var remaining_time = int(start_timer.time_left) + 1
	if remaining_time < 5 && remaining_time > 0: countdown_label.text = str(remaining_time)

func update_return_label():
	var remaining_time = int(finish_timer.time_left) + 1
	if remaining_time < 4 && remaining_time > 0: 
		return_label.text = "Returning to casino (%d)...." % remaining_time

func spawn_finish_line():
	finish_line = finish_line_SCENE.instantiate()
	finish_line.position = SPAWN_POSITION
	finish_line.body_entered.connect(_on_finish_line_crossed)
	add_child(finish_line)

func play_sound_at_random_interval():
	# Generate random delay (e.g., 5-15 seconds)
	var delay =randf_range(0.7,1.5)
	await get_tree().create_timer(delay).timeout
	# Play sound
	$Audio/whips.play()
	if finish_timer.is_stopped():
		play_sound_at_random_interval()

func set_win_labels():
	if win:
		$UI/WinPanel/HBoxContainer/Results.text = """2nd: %s
	3rd: %s
	""" % [winners[1], winners[2]]
	else:
		$UI/WinPanel/HBoxContainer/Results.text = """Top Horse: %s
	2nd: %s
	3rd: %s
	""" % [winners[0], winners[1], winners[2]]
	
	
func _on_start_timer_timeout():
	countdown_label.text = "AND THEY'RE OFF!"
	race_timer.start()
	start_race.emit()
	await get_tree().create_timer(1).timeout
	countdown_label.visible = false


func _on_finish_line_crossed(body):
	winners.append(body.name)
	body.finished_race()
	end_race.emit()
	if end_race.is_connected(on_race_finished):
		end_race.disconnect(on_race_finished)
	
	#Play winning bell
	$Audio/win_bell.play(0.3)

func on_race_started():
	race_started = true
	
	#Play horse sounds
	$Audio/galloping.play()
	play_sound_at_random_interval()
	$Audio/whips.play()

func on_race_finished():
	finish_timer.start()
	if your_bet:
		if !winners.is_empty() && winners[0] && str(winners[0]).contains(your_bet["horse"]):
			$UI/WinPanel/HBoxContainer/Title.text = "And the winner is...\n" + str(winners[0])
			win = true
		else:
			$UI/WinPanel/HBoxContainer/Title.text = "Better luck next time...\n"
			win = false
	win_anim.play("popup")

func _on_race_timer_timeout() -> void:
	spawn_finish_line()

func _on_finish_timer_timeout() -> void:
	if winners.size() >= 3:
		#print("1st place: %s \n2nd place: %s \n3rd place: %s" % [winners[0],winners[1], winners[2]])
		pass
	return_label.text = "Returning to casino (0)...."
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(casino)

func score_announced():
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "popup":
		$UI/WinPanel/HBoxContainer/Winnings.score_announced.connect(score_announced)
		if your_bet:
			if win:
				$UI/WinPanel/HBoxContainer/Winnings.start_effect(your_bet["amount"])
				$Audio/win_result.play()
			else:
				$UI/WinPanel/HBoxContainer/Winnings.start_effect(-(your_bet["amount"]))
				$Audio/lose_result.play()
				await get_tree().create_timer(1.25).timeout
				$Audio/lose_result2.play()
		else:
			$UI/WinPanel/HBoxContainer/Winnings.start_effect(0)
