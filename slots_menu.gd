extends Node2D

var casino ="res://Scenes/casino.tscn";
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_slots_game_exit_pressed() -> void:
	get_tree().change_scene_to_file(casino)
