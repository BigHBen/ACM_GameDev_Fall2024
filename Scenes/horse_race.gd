extends Node2D

var race_speed_scale = 3.0
@onready var start_timer = $Start_Timer
@onready var countdown_label = $UI/Label

@onready var dirt_track = $CanvasLayer/ParallaxBackground/ParallaxLayer/dirt_track
@onready var race_timer = $RaceTimer
@onready var finish_timer = $FinishTimer

var start_position = Vector2(-300,260)
var race_started = false

@onready var minigame_manager = get_node("/root/MinigameManager")

#instance for finish line sprite
var finish_line

const finish_line_SCENE = preload("res://Scenes/finish_line.tscn")  # Replace with your finish_line scene
const SPAWN_POSITION = Vector2(2396, 1260)  # Initial spawn position

#Horses
var horse_counter = 0
var horse_preload = preload("res://Scenes/horse.tscn")
var horse = null
var horses = []
@export var num_horses = 5

#End conditions
var winners = []
signal start_race()
signal end_race()




# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_horses()
	start_race.connect(on_race_started)
	end_race.connect(on_race_finished)
	start_timer.start()

func _process(_delta):
	if !start_timer.is_stopped():
		update_label()
	if finish_line:
		finish_line.position.x -= 20

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
		
		horse.name = "Horse_" + str(horse_counter)
		horse_counter += 1
		horse.generate_positions()
		add_child(horse)
func watch_for_winner():
	var dirt_track_parallax = $CanvasLayer/ParallaxBackground/ParallaxLayer
	var line_distance = finish_line.get_global_position() + dirt_track_parallax.motion_offset
	finish_line.position.x = line_distance.x

func update_label():
	var remaining_time = int(start_timer.time_left) + 1
	if remaining_time < 4 && remaining_time > 0: countdown_label.text = str(remaining_time)

func spawn_finish_line():
	finish_line = finish_line_SCENE.instantiate()
	finish_line.position = SPAWN_POSITION
	finish_line.body_entered.connect(_on_finish_line_crossed)
	add_child(finish_line)

func _on_start_timer_timeout():
	countdown_label.text = "AND THEY'RE OFF!"
	race_timer.start()
	start_race.emit()

func _on_finish_line_crossed(body):
	winners.append(body.name)
	body.finished_race()
	end_race.emit()
	

func on_race_started():
	race_started = true

func on_race_finished():
	finish_timer.start()
	

func _on_race_timer_timeout() -> void:
	spawn_finish_line()

func _on_finish_timer_timeout() -> void:
	print("1st place: %s \n2nd place: %s \n3rd place: %s" % [winners[0],winners[1], winners[2]])
