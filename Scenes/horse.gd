extends CharacterBody2D


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

@onready var start_position = self.position
var goal_pos = 100.0

var box_size = 20.0
var box_color = Color.LIGHT_SALMON

var horse_max_position

func _ready():
	get_parent().start_race.connect(get_moving)
	set_physics_process(false)

func _physics_process(delta):
	
	if position.x < positions[0].x:
		velocity.x = move_toward(velocity.x, horse_speed, horse_acc * delta)
	else:
		velocity.x = 0
		second_timer += delta
		if second_timer > move_tick:
			#speed_burst(rng.randi_range(1, 3))
			move(rng.randi_range(1, 3))
			second_timer = 0
	move_and_slide()

func speed_burst(value):
	var new_speed = float(horse_speed * horse_speeds[value])
	var new_max_position = position.x + sign(new_speed) * 50
	print(new_speed)
	if sign(new_speed) > 0 && position.x < max_field_pos:
		if position.x < new_max_position:
			velocity.x = new_speed
		else: velocity.x = 0
	else:
		if position.x > new_max_position:
			velocity.x = new_speed
		else: velocity.x = 0
			
	#if position.x < new_max_position && position.x < max_field_pos:
		#velocity.x = new_speed
	#else: velocity.x = 0

func move(value):
	
	match value:
		1:
			var index = positions.find(curr_space)
			
			if index >= 0 && index <= positions.size() - 1:
				curr_space = positions[positions.find(curr_space) - 1]
		2:
			curr_space = positions[positions.find(curr_space)]
		3:
			var index = positions.find(curr_space)
			
			if index >= 0 && index < positions.size() - 1:
				curr_space = positions[positions.find(curr_space) + 1]
	position.x = curr_space.x

func get_moving():
	set_physics_process(true)


func generate_positions():
	var space = TRACK_LENGTH / num_pos
	
	for i in range(num_pos):
		var track_position = Vector2(initial_pos + i * space,position.y)
		positions.append(track_position)
	
	curr_space = positions[0]
	print(positions)

func set_curr_space(new_space):
	curr_space = new_space

func get_curr_space():
	return curr_space
	
func _draw():
	for pos in positions:
		var rect = ColorRect.new()
		rect.position = pos - Vector2(box_size / 2, box_size /2)
		rect.set_size(Vector2(box_size,box_size))
		rect.color = box_color
		
		get_parent().add_child(rect)
