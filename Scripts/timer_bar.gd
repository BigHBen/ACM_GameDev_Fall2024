extends Control

@export var DEBUG_MODE = false
@onready var GAME_TIMER : Timer = get_node("/root/CasinoTimer")
@onready var progress_bar = $TextureProgressBar
@onready var clock = $TextureProgressBar/Timerclock
@onready var clock_flame = $flame
@onready var timer_anim : AnimationPlayer = $"TextureProgressBar/Timerclock/AnimationPlayer"

var clock_halfway = false

signal halfway
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = GAME_TIMER.bar_value
	if clock_halfway: progress_bar.tint_progress = Color(0.903,0.455,0.446,1)
	halfway.connect(progress_halfway)
	if DEBUG_MODE: 
		GAME_TIMER.GAME_TIME = 5
		GAME_TIMER.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GAME_TIMER.elapsed_time >= (float(GAME_TIMER.GAME_TIME) / 2):
		halfway.emit()
		if halfway.is_connected(progress_halfway):
			halfway.disconnect(progress_halfway)
	if GAME_TIMER.GAME_TIME > 0 && !GAME_TIMER.is_stopped():
		update_progress(float(GAME_TIMER.GAME_TIME - GAME_TIMER.elapsed_time),float(GAME_TIMER.GAME_TIME))
	
	#Stop processes once game timer stops
	if GAME_TIMER.is_stopped():
		clock_flame.stop()
		clock_flame.visible = false
		clock.stop()
		set_process(false)
		
func update_progress(s,t):
	progress_bar.value = (s / t) * 100.0
	GAME_TIMER.bar_value = progress_bar.value

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print(GAME_TIMER.GAME_TIMER.elapsed_time)

func progress_halfway():
	clock_halfway = true
	clock_flame.visible = true
	clock_flame.play("default")
	timer_anim.play("switch")
