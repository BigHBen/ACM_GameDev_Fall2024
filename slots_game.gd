extends Node2D

var Bet = 10
var win = 0
var slots = ["res://Assets/random_photos/Bell.png",
			"res://Assets/random_photos/Cherries.png",
			"res://Assets/random_photos/Diamond.png",
			"res://Assets/random_photos/seven.png"]
@onready var button: Button = $Control/Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Randomized_Pic()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func Randomized_Pic():
	var pic1 = randi_range(0,3)
	var pic2 = randi_range(0,3)
	var pic3 = randi_range(0,3)
	button.disabled = true
	await get_tree().create_timer(3.0).timeout
	
	$Control/Panel/HBoxContainer/Slot1.texture = load(slots[pic1])
	$Control/Panel/HBoxContainer/Slot2.texture = load(slots[pic2])
	$Control/Panel/HBoxContainer/Slot3.texture = load(slots[pic3])
	if (pic1 == pic2 && pic1==pic3):
		match pic1:
			0:
				win = Bet*5
			1:
				win = Bet*2
			2:
				win = Bet*3
			3:
				win = Bet*10
			_:
				print("Error")
		print("You Win:",win)
	else:
		print("You lose")
	button.disabled = false
	
	


func _on_Replay_pressed() -> void:
	Randomized_Pic()
