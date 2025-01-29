extends Control

@onready var video_player : VideoStreamPlayer = $VideoStreamPlayer
var main_menu = "res://Scenes/main_menu.tscn"
var END_SCENE_DICT = {
	"ending1" : "res://Assets/Videos/Cutscenes/casinoendingscene_1.ogv",
	"ending2" : "res://Assets/Videos/Cutscenes/CasinoEndingScene_2.ogv"
}
var video_lengths : float = 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random_key = END_SCENE_DICT.keys()[randi() % END_SCENE_DICT.size()]
	# Get the value associated with that key
	var random_value = END_SCENE_DICT[random_key]
	
	# Set random ending cutscene
	video_player.stream = load(random_value)
	video_player.play()

func _process(_delta: float) -> void:
	if video_player.stream_position >= video_lengths:
		set_process(false)
		video_player.paused = true
		$Gameovertext.visible = true
		fade_in($Gameovertext/TEXT,2.0)
		fade_out(self,4.0)
		

func fade_in(s,sec:float):
	s.modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(s, "modulate", Color(1, 1, 1, 1), sec)

func fade_out(s,sec:float):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(s, "modulate", Color(0, 0, 0, 1), sec)
	await tween.finished
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(main_menu)
