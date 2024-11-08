extends Timer

var seconds_passed = 0
var elapsed_time : float = 0

var bar_value = 0

@onready var alarm = $alarm

@export_range(10,120) var GAME_TIME : int = 10

func _ready():
	self.timeout.connect(_on_game_timer_timeout)
	#start()

func _process(delta: float) -> void:
	if !is_stopped():
		elapsed_time += delta

func _on_game_timer_started():
	#print("Time left: " , GAME_TIME - seconds_passed)
	pass

func _on_game_timer_timeout():
	seconds_passed += 1
	#print("Time left: " , GAME_TIME - seconds_passed)
	
	if elapsed_time >= GAME_TIME:
		alarm.play()
		stop()
