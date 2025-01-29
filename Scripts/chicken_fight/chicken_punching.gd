extends Node2D

var score = 0

#	this variable loads the scene and hitbox for the rhythm icon, so instances can be made
#	of it.
var punch_spawn_scene = preload("res://Scenes/chicken_fight/punch_spawn.tscn")
@onready var global_scene = get_node("/root/MinigameManager")

#	these two timers are necessary so that the rhythm icons aren't impossible to hit, and
#	so that a player cannot just spam click the button to win the minigame.
@onready var spawn_punch_timer = $spawn_punch_timer
@onready var can_hit_timer = $can_hit_timer
@onready var temp_punch_timer = $"temp punch ani"

#	temp fists
@onready var fists1 = $PlaceholderFists2
@onready var fists2 = $PlaceholderPunch

@onready var win_panel = $WinPanel
@onready var win_anim : AnimationPlayer = $WinPanel/AnimationPlayer


@onready var miss_label = $MissLabel
@onready var return_label = $WinPanel/HBoxContainer/Return

var casino = "res://Scenes/casino.tscn" #Minigame select scene

#	these booleans are to check if a rhythm icon has spawned, and if it has, then it will
#	check whether it was perfectly aligned with the line, or if it was off the line.
var is_spawned = false

var WIN_AMOUNT : int = 0 # Changes player balance

#Status
var perfect_hit = []
var meh_hit = []

#	this variable holds where the hit will spawn on the game, above the screen for now.
var spawn_position = Vector2(299, -40)

#	this variable is for the can_hit_timer variable, and it is just a boolean to see if the
#	player is allowed to punch yet.
var can_hit = true;

#	chicken's health bar, if it depletes, then the minigame should end.
#var chicken_health = 30


@onready var chicken_health_bar = $PlaceholderChicken/HealthProgressBar

#Changes progress bar
@export var chicken_health = 30 : set=set_chicken_health, get=get_chicken_health



#	testing the minigame with a boolean
var game_started_testing = false

# Start game with timer
@onready var start_timer = $Start_Timer
@onready var countdown_label = $Start_Timer/StartCountdown
@onready var finish_timer = $FinishTimer

func _ready() -> void:
	
	fists2.hide()
	
	print("\nWelcome to Chicken Fight!")
	print("Get Ready! (Starting Countdown)")
	#Start game countdown
	start_timer.start()

func start_game():
	start_timer.stop()
	countdown_label.text = "START!"
	game_started_testing = true
	await get_tree().create_timer(1).timeout
	countdown_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#Start Timer Label Stuff
	if chicken_health <= 0: #When chicken is done for
		#beat_chicken()
		if !finish_timer.is_stopped():
			update_return_label()
	else:
		if !start_timer.is_stopped():
			update_start_label()
		if(game_started_testing && !is_spawned && chicken_health > 0):
			spawn_hit()
			is_spawned = true
			wait_for_next_hit()

func update_start_label():
	var remaining_time = int(start_timer.time_left) + 1
	if remaining_time < start_timer.wait_time && remaining_time > 0: 
		countdown_label.text = str(remaining_time)

func update_return_label():
	var remaining_time = int(finish_timer.time_left) + 1
	if remaining_time < 4 && remaining_time > 0: 
		return_label.text = "Returning to casino (%d)...." % remaining_time

func beat_chicken():
	
	game_started_testing = false
	score += 100
	
	$WinPanel/HBoxContainer/Title.text = "YOU BEAT THE CHICKEN: %s" % [score]
	win_anim.play("popup")
	#$Audio/win_result.play()
	finish_timer.start()


# Constantly checking if the player has clicked anywhere on the viewport
func _input(event):
	
	#Check if player presses space before/during start timer countdown
	if !game_started_testing && event.is_action_pressed("ui_accept"):
		start_game()
	
	# Ensure the event is a mouse button event
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if game_started_testing:
			_user_clicked()
		else:
			start_game()

#	if the player has clicked, then this will check whether it was a miss or not, and then
#	set the timer to force the user to wait until they can click again.
func _user_clicked() -> void:
	if game_started_testing && can_hit:
		_play_punch()
		if(!perfect_hit.is_empty() && perfect_hit[0]):
			#Play hit animation for Punchfist
			if perfect_hit[1]:
				perfect_hit[1].hit_label.text = "PERFECT"
				perfect_hit[1].animator.play("punch_hit")
				$"Audio/Punch!".play(2)
			perfect_hit = null
			
			#Lower chicken health
			chicken_health -= 3
			print("perfect")
			print("chicken health is now: ", chicken_health, "\n")
		elif(!meh_hit.is_empty() && meh_hit[0]):
			#Play hit animation for Punchfist
			if meh_hit[1]:
				meh_hit[1].hit_label.text = "MEH"
				meh_hit[1].animator.play("punch_hit")
				$"Audio/Punch!".play(2)
			meh_hit = null
			
			chicken_health -= 2
			
			print("meh")
			print("chicken health is now: ", chicken_health, "\n")
			
		else:
			print("miss")
			$Audio/Whiff.play()
			print("chicken health is still: ", chicken_health, "\n")
			show_miss_label()
		can_hit = false
		wait_for_next_click()
	else:
		print("can't punch yet!")

func show_miss_label():
	miss_label.visible = true
	await get_tree().create_timer(0.5).timeout
	miss_label.visible = false

#	this function spawns the rhythm icons by adding a child to the instance.
#	when the instance reaches below a certain y position, it will automatically free
#	itself.
func spawn_hit() -> void:
	var punch_spawn_instance = punch_spawn_scene.instantiate()
	punch_spawn_instance.name = "PunchFist" + str(punch_spawn_instance.get_instance_id())
	punch_spawn_instance.position = spawn_position 
	add_child(punch_spawn_instance)

#	timers for the two things
func wait_for_next_hit() -> void:
	spawn_punch_timer.start(0.50 * randi_range(1, 3))

func wait_for_next_click() -> void:
	can_hit_timer.start(0.35)

func set_chicken_health(value):
	chicken_health = value
	var percentage = (chicken_health / 100.0) * 3
	
	if chicken_health_bar:
		if percentage >= 0.75:
			chicken_health_bar.value = 3  
		elif percentage >= 0.25:
			chicken_health_bar.value = 2  
		elif percentage > 0:
			chicken_health_bar.value = 1  
		else:
			chicken_health_bar.value = 0 
			beat_chicken()

func get_chicken_health():
	return chicken_health
#	when the timer for its respective type runs out, it will set the boolean back to its
#	original value.
func _on_spawn_punch_timer_timeout() -> void:
	is_spawned = false

func _on_can_hit_timer_timeout() -> void:
	can_hit = true

#	i don't really know a better way to do this, but there are 'invisible' (not while debugging)
#	hitboxes to determine where the rhythm icon is to deal damage accordingly to how close the
#	user got to clicking on time.
func _on_perfect_zone_area_entered(area: Area2D) -> void:
	var punch_node = area
	if punch_node is PunchFist:
		perfect_hit = [true,punch_node]

func _on_perfect_zone_area_exited(area: Area2D) -> void:
	var punch_node = area
	if punch_node is PunchFist:
		perfect_hit = [false,punch_node]

func _on_meh_zone_area_entered(area: Area2D) -> void:
	var punch_node = area
	if punch_node is PunchFist:
		meh_hit = [true,punch_node]
	
func _on_meh_zone_area_exited(area: Area2D) -> void:
	var punch_node = area
	if punch_node is PunchFist:
		meh_hit = [false,punch_node]

#Click button to start chicken fight
func _on_button_pressed() -> void:
	game_started_testing = true

func _play_punch() -> void:
	fists1.hide()
	fists2.show()
	temp_punch_timer.start(0.1)

func _on_temp_punch_ani_timeout() -> void:
	fists1.show()
	fists2.hide()

func _on_start_timer_timeout() -> void:
	start_game()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "popup":
		#Will be passed to minigame manager -> Added to player balance
		WIN_AMOUNT = score
		$WinPanel/HBoxContainer/Winnings.start_effect(score)
		#$Audio/win_result.play()
		await get_tree().create_timer(1.25).timeout
		global_scene.set_winning_bet(global_scene.winning_bet + WIN_AMOUNT)


func _on_finish_timer_timeout() -> void:
	return_label.text = "Returning to casino (0)...."
	global_scene.minigame_count += 1
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(casino)
