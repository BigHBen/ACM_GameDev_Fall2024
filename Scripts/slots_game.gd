extends Node2D

var Bet = 10
var win = 0

@onready var button: Button = $Control/Button
@onready var slot: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot
@onready var slot2: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot2
@onready var slot3: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot3
@onready var result1: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot_pic
@onready var result2: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot2_pic
@onready var result3: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot3_pic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Randomized_Pic()
	
func Randomized_Pic():
	var slot1_result = randi_range(0,3)
	var slot2_result = randi_range(0,3)
	var slot3_result = randi_range(0,3)
	button.disabled = true
	slot.play("default")
	slot2.play("default")
	slot3.play("default")
	slot.visible = true
	slot2.visible = true
	slot3.visible = true
	result1.visible = false
	result2.visible = false
	result3.visible = false
	await get_tree().create_timer(3.0).timeout
	slot.pause()
	slot2.pause()
	slot3.pause()
	
	slot.visible = false
	slot2.visible = false
	slot3.visible = false
	
	result1.visible = true
	result2.visible = true
	result3.visible = true
	
	Slots_Results(result1, slot1_result)
	Slots_Results(result2, slot2_result)
	Slots_Results(result3, slot3_result)
	
	button.disabled = false
	
	win = Check_Results(slot1_result, slot2_result, slot3_result, Bet)

func Slots_Results(INslot, result):
	match result:
		0:
			INslot.texture = load("res://Assets/random_photos/seven.png")
			pass
		1:
			INslot.texture = load("res://Assets/random_photos/Diamond.png")
			pass
		2:
			INslot.texture = load("res://Assets/random_photos/Cherries.png")
			pass
		3:
			INslot.texture = load("res://Assets/random_photos/Bell.png")
			pass

func Check_Results(Result1, Result2, Result3, bet):
	var winnings = 0
	if (Result1 == Result2) and (Result2 == Result3):
		match Result1:
			0:
				winnings = bet * 10
				pass
			1:
				winnings = bet * 5
				pass
			2:
				winnings = bet * 2
				pass
			3:
				winnings = bet * 3
				pass
		print("You've Won: " )
		print(winnings)
	else:
		print("You Lost!")
	return winnings

func _on_Replay_pressed() -> void:
	Randomized_Pic()
