extends Label

var rng = RandomNumberGenerator.new()
var target_value = 0
var duration = 1

var elapsed = 0

var color1 = Color(1, 1, 1)
var color2 = Color(1, 0, 0)

signal score_announced

func _ready():
	if get_tree().current_scene.name == "horse_race": 
		set_process(false)
	else:
		start_effect(10)
func start_effect(target):
	target_value = target
	rng.randomize()
	set_process(true)

func _process(delta: float) -> void:
	if elapsed < duration:
		text = "$" + str(rng.randi_range(0, 100))  # adjust range
		elapsed += delta
		var ratio = elapsed / duration
		var new_color_red = Color(1,1 -0.7 * ratio, 1 - 0.7 * ratio)
		var new_color_green = Color(1 - ratio, 0.7 + 0.1 * ratio, 0)
		
		if sign(target_value) > 0:
			self.label_settings.font_color = new_color_green
		elif sign(target_value) < 0:
			self.label_settings.font_color = new_color_red
	else:
		text = ("+" if target_value > 0 else "-") + "$" + str(abs(target_value)) if target_value != 0 else "$0"
		score_announced.emit()
		set_process(false)
