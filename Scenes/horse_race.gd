extends Node2D

var race_speed_scale = 3.0
@onready var start_timer = $Start_Timer
@onready var countdown_label = $UI/Label
@onready var horse = $Horse


var start_position = Vector2(-344,344)
var race_started = false

signal start_race()




# Called when the node enters the scene tree for the first time.
func _ready():
	horse.position = start_position
	horse.generate_positions()
	start_race.connect(on_race_started)
	start_timer.start()

func _process(_delta):
	if !start_timer.is_stopped():
		update_label()
		

func update_label():
	var remaining_time = int(start_timer.time_left) + 1
	if remaining_time < 4 && remaining_time > 0: countdown_label.text = str(remaining_time)

func _on_start_timer_timeout():
	countdown_label.text = "AND THEY'RE OFF!"
	start_race.emit()


func on_race_started():
	race_started = true

