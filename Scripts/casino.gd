extends Node2D


#Dictionary w minigame scene paths
var minigames =  {
	horse_minigame = "res://Scenes/horse_race_menu.tscn", #Minigame select scene
	slots_minigame = "res://Scenes/slots_menu.tscn"
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_horse_minigame_pressed() -> void:
	#Go to horse racing menu
	get_tree().change_scene_to_file(minigames["horse_minigame"])


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_slots_minigame_pressed() -> void:
	get_tree().change_scene_to_file(minigames["slots_minigame"])
