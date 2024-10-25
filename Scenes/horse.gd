extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D
var horse_speed = 300
var horse_acc = 500

var on_field = false

#How far the horse can run foward
var max_field_pos = 850

#Change speed every second
var second_timer = 0.0
var rng = RandomNumberGenerator.new()
var my_random_number

var horse_speeds = {
	1: -1.1,
	2: 1.0,
	3: 1.1,
}

#Move horse each second
var move_tick = 0.25


#Horse 'teleports' across spaces in positions array
var curr_space = Vector2.ZERO : set = set_curr_space ,get = get_curr_space

#Split track into several positions
const TRACK_LENGTH = 1152.0
var initial_pos = 48
var num_pos = 12
var positions = []

#Position Boxes

var goal_pos = 100.0

var box_size = 20.0
var box_color = Color.LIGHT_SALMON

var horse_max_position

var finished = false

func _ready():
	sprite.modulate = Color(randf(), randf(), randf(), 1)
	get_parent().start_race.connect(get_moving)
	set_physics_process(false)

func _physics_process(delta):
	if position.x < positions[0].x:
		velocity.x = move_toward(velocity.x, horse_speed, horse_acc * delta)
	elif not finished:
		velocity.x = move_toward(velocity.x, 0, horse_acc * delta)
		second_timer += delta
		transition(curr_space.x-position.x)
		if second_timer > move_tick:
			#speed_burst(rng.randi_range(1, 3))
			if abs(position.x - curr_space.x) < 0.1:
				move(rng.randi_range(1, 3))
			second_timer = 0
	elif finished:
		velocity.x = horse_speed * 4
	move_and_slide()

#func speed_burst(value):
	#var new_speed = float(horse_speed * horse_speeds[value])
	#var new_max_position = position.x + sign(new_speed) * 50
	#print(new_speed)
	#if sign(new_speed) > 0 && position.x < max_field_pos:
		#if position.x < new_max_position:
			#velocity.x = new_speed
		#else: velocity.x = 0
	#else:
		#if position.x > new_max_position:
			#velocity.x = new_speed
		#else: velocity.x = 0
			#
	##if position.x < new_max_position && position.x < max_field_pos:
		##velocity.x = new_speed
	##else: velocity.x = 0

func move(value):
	var index = positions.find(curr_space)
	match value:
		1:  # Move left
			index = max(0, index - 1)
		2:  # Stay at current position (no change needed)
			pass
		3:  # Move right
			index = min(positions.size() - 1, index + 1)
	if value != 2:
		curr_space = positions[index]
	#position.x = curr_space.x

func transition(distance):
	position.x = move_toward(position.x, position.x + distance, horse_speed * 1.5 * get_process_delta_time())

func get_moving():
	set_physics_process(true)


func generate_positions():
	var space = TRACK_LENGTH / num_pos
	
	for i in range(num_pos):
		var track_position = Vector2(initial_pos + i * space,position.y)
		positions.append(track_position)
	
	curr_space = positions[0]

func set_curr_space(new_space):
	curr_space = new_space
	#print(curr_space)

func get_curr_space():
	return curr_space

func finished_race():
	finished = true

#func _draw():
	#for pos in positions:
		#var rect = ColorRect.new()
		#rect.position = pos - Vector2(box_size / 2, box_size /2)
		#rect.set_size(Vector2(box_size,box_size))
		#rect.color = box_color
		#
		#get_parent().add_child(rect)
