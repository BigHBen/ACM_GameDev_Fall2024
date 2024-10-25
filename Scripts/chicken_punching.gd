extends Node2D

var score = 0

#	this variable loads the scene and hitbox for the rhythm icon, so instances can be made
#	of it.
var punch_spawn_scene = preload("res://Scenes/punch_spawn.tscn")
@onready var global_scene = get_node("/root/MinigameManager")

#	these two timers are necessary so that the rhythm icons aren't impossible to hit, and
#	so that a player cannot just spam click the button to win the minigame.
@onready var spawn_punch_timer = $spawn_punch_timer
@onready var can_hit_timer = $can_hit_timer

#	these booleans are to check if a rhythm icon has spawned, and if it has, then it will
#	check whether it was perfectly aligned with the line, or if it was off the line.
var is_spawned = false
var perfect_hit = false
var meh_hit = false

#	this variable holds where the hit will spawn on the game, above the screen for now.
var spawn_position = Vector2(299, -40)

#	this variable is for the can_hit_timer variable, and it is just a boolean to see if the
#	player is allowed to punch yet.
var can_hit = true;

#	chicken's health bar, if it depletes, then the minigame should end.
var chicken_health = 30

#	testing the minigame with a boolean
var game_started_testing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(game_started_testing && !is_spawned && chicken_health > 0):
		spawn_hit()
		is_spawned = true
		wait_for_next_hit()
	if chicken_health <= 0: #When chicken is done for
		score += 1
		print("YOU BEAT THE CHICKEN: %s" % [score])
		set_process(false)

#	constantly checking if the player has clicked yet anywhere on the viewport
func _input(event):
	if(event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		_user_clicked()

#	if the player has clicked, then this will check whether it was a miss or not, and then
#	set the timer to force the user to wait until they can click again.
func _user_clicked() -> void:
	if(can_hit):
		if(perfect_hit):
			print("perfect")
			chicken_health -= 3
			print("chicken health is now: ", chicken_health)
		else: if(meh_hit):
			chicken_health -= 2
			print("chicken health is now: ", chicken_health)
			print("meh")
		else:
			print("miss")
			print("chicken health is still: ", chicken_health)
		
		can_hit = false
		wait_for_next_click()
	else:
		print("can't punch yet!")

#	this function spawns the rhythm icons by adding a child to the instance.
#	when the instance reaches below a certain y position, it will automatically free
#	itself.
func spawn_hit() -> void:
	var punch_spawn_instance = punch_spawn_scene.instantiate()
	punch_spawn_instance.position = spawn_position 
	add_child(punch_spawn_instance)

#	timers for the two things
func wait_for_next_hit() -> void:
	spawn_punch_timer.start(0.50 * randi_range(1, 3))

func wait_for_next_click() -> void:
	can_hit_timer.start(0.35)

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
	perfect_hit = true

func _on_perfect_zone_area_exited(area: Area2D) -> void:
	perfect_hit = false

func _on_meh_zone_area_entered(area: Area2D) -> void:
	meh_hit = true
	
func _on_meh_zone_area_exited(area: Area2D) -> void:
	meh_hit = false

func _on_button_pressed() -> void:
	game_started_testing = true
