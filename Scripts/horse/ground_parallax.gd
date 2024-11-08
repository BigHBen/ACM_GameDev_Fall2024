extends ParallaxBackground


const MAX_SPEED = 200.0  # Maximum scroll speed
const ACCELERATION = 300.0  # Acceleration rate


var scroll_speed = 0.0  # Current scroll speed
var slow_down = false
var started = false

func _ready():
	#set_process(false)
	$"../..".start_race.connect(accelerate)
	$"../..".end_race.connect(deccelerate)

func accelerate():
	#set_process(true)
	started = true

func deccelerate():
	slow_down = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target_layer = $ParallaxLayer2
	target_layer.motion_offset -= Vector2(min(MAX_SPEED, scroll_speed + ACCELERATION * delta), 0) * get_parent().get_parent().race_speed_scale * delta
	if started:
		if !slow_down: scroll_speed = min(MAX_SPEED, scroll_speed + ACCELERATION * delta)
		else: scroll_speed = max(0, scroll_speed - ACCELERATION * delta)
		scroll_base_offset -= Vector2(scroll_speed, 0) * $"../..".race_speed_scale * delta
