extends Timer

const GAME_TIME_DEFAULT = 10
const HOME_SCENE = "res://Scenes/hub.tscn"
const GAME_OVER = "res://Scenes/game_over.tscn"

# Autoload Global Variables
@onready var minigame_manager = get_node("/root/MinigameManager")
@onready var currency_manager = get_node("/root/CurrencyManager")
# Scene variables
@onready var alarm = $Alarm
@onready var return_timer = $ReturnTimer
@onready var timer_bar = $TimerBar
@onready var progress_bar = $TimerBar/TextureProgressBar
@onready var clock = $TimerBar/TextureProgressBar/Timerclock
@onready var clock_flame = $TimerBar/Flame
@onready var timer_anim = $TimerBar/TextureProgressBar/Timerclock/AnimationPlayer
@onready var timer_win_anim = $TimeoutPanel/AnimationPlayer
@onready var timer_return_label = $TimeoutPanel/VBoxContainer/Return

# Properties
@export_range(1,120) var game_time = GAME_TIME_DEFAULT : set = set_game_time,  get = get_game_time
@export var debug_mode = false
var clock_halfway = false
var clock_done = false
var elapsed_time = 0.0
var seconds_passed = 0

var current_scene = null

# Signals
signal halfway

func _ready():
	timer_bar.visible = false
	$fade_panel.modulate = Color(0,0,0,0)
	if debug_mode:
		start_timer()

func start_timer(new_time := GAME_TIME_DEFAULT):
	
	#Set new casino time (if provided)
	set_game_time(new_time)
	
	timer_bar.visible = true
	reset_timer()
	start()
	set_process(true)

func _process(delta):
	if game_time > 0 && !is_stopped():
		elapsed_time += delta
		seconds_passed = int(elapsed_time)
		update_progress(elapsed_time)
		check_halfway()
		check_timeout()

func update_progress(elapsed):
	progress_bar.value = (game_time - elapsed) / float(game_time) * 100
	if elapsed >= game_time / 2.0:
		halfway.emit()

func check_halfway():
	if elapsed_time >= game_time / 2.0 && !clock_halfway:
		clock_halfway = true
		clock_flame.visible = true
		clock_flame.play("default")
		timer_anim.play("switch")

func check_timeout():
	if elapsed_time >= game_time && !clock_done:
		clock_done = true
		print("Time's up!")
		timer_bar.visible = false
		alarm.play(0.3)
		return_timer.start()
		stop()
		pause_scene()
		
		time_elapsed_effects()
		set_process(false)

func pause_scene():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	#Pause current scene
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED

func check_debt():
	var current_bill = currency_manager.debt
	if current_bill == 0: currency_manager.debt_count = 0
	else: currency_manager.debt_count += 1
	
	#print("Your in for %d more rounds" % [currency_manager.MAX_DEBT_COUNT-currency_manager.debt_count])
	if currency_manager.debt_count > currency_manager.MAX_DEBT_COUNT:
		game_over()
		return true
	return false

func game_over() -> void:
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($fade_panel, "modulate", Color(0, 0, 0, 1), 2.0)
	await tween.finished
	print("Debt for too long, GAME OVER")
	for node in self.get_children():
		if node is not Timer:
			node.visible = false
	reset_timer()
	get_tree().change_scene_to_file(GAME_OVER)

func reset_timer():
	elapsed_time = 0.0
	seconds_passed = 0
	clock_halfway = false
	clock_done = false
	timer_anim.play("RESET")
	timer_win_anim.play("RESET")

func time_elapsed_effects():
	timer_win_anim.play("popup")
	clock.stop()
	timer_anim.play("shake")
	await get_tree().create_timer(0.25).timeout
	clock_flame.visible = false

#Setter/Getter - 
#(IDEA) - Purchaseable item to extend minigame time
func set_game_time(value):
	game_time = value

func get_game_time():
	return game_time

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"popup":
			if !check_debt():
				var total = minigame_manager.winning_bet
				$TimeoutPanel/VBoxContainer/HBoxContainer/Winnings.start_effect(total)
				timer_return_label.text = "Time to go back home...."
				timer_win_anim.play("countdown")
			else:
				timer_return_label = ""
		"countdown":
				reset_timer()
				get_tree().change_scene_to_file(HOME_SCENE)
