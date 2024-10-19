extends Node2D

var Bet = 10
var win = 0

# Variables for nodes in scene
@onready var button: Button = $Control/Button
@onready var slot: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot
@onready var slot2: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot2
@onready var slot3: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot3
@onready var result1: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot_pic
@onready var result2: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot2_pic
@onready var result3: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot3_pic

# By the way you can edit the animation that plays in the slot_animation scene
# Main use for editing is increasing or decreasing the frames per second in order to change how fast the animation plays
# Experiment with different values to see what looks nice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Randomized_Pic()
	
func Randomized_Pic():
	# Calculate what each slot landed on to be used in later functions
	var slot1_result = randi_range(0,3)
	var slot2_result = randi_range(0,3)
	var slot3_result = randi_range(0,3)
	
	# Hides the results and shows the slots animation.
	# Also temporarily removes the play button to prevent multiple inputs
	Slots_Start()
	# Lets the animation play for 3 seconds for finalizing and letting the rest of the code play.
	await get_tree().create_timer(3.0).timeout
	# Shows the results and hides the slots animation
	Slots_End()
	
	# When given the Sprite2D of one of the slots and the value calculated for it at the start of the code:
	# Change the texture of the designated Sprite2D to a specified image given by the initial value
	Slots_Results(result1, slot1_result)
	Slots_Results(result2, slot2_result)
	Slots_Results(result3, slot3_result)
	
	# Checks if you've won and multiplies your bet by a set amount depending on the combination given
	win = Check_Results(slot1_result, slot2_result, slot3_result, Bet)

# Explainations for functions mostly given in Randomize_Pic function
func Slots_Results(INslot, result):
	match result:
# Seven
		0:
			INslot.texture = load("res://Assets/random_photos/seven.png")
			pass
# Diamond
		1:
			INslot.texture = load("res://Assets/random_photos/Diamond.png")
			pass
# Cherries
		2:
			INslot.texture = load("res://Assets/random_photos/Cherries.png")
			pass
# Bell
		3:
			INslot.texture = load("res://Assets/random_photos/Bell.png")
			pass

func Check_Results(Result1, Result2, Result3, bet):
	var winnings = 0
	if (Result1 == Result2) and (Result2 == Result3):
		match Result1:
# If All 7s
			0:
				winnings = bet * 10
				pass
# If All Diamonds
			1:
				winnings = bet * 5
				pass
# If All Cherries
			2:
				winnings = bet * 2
				pass
# If All Bells
			3:
				winnings = bet * 3
				pass
		print("You've Won: " )
		print(winnings)
	else:
		print("You Lost!")
	return winnings

func Slots_Start():
	# Disable the play again button
	button.disabled = true
	# Start the animation
	slot.play("default")
	slot2.play("default")
	slot3.play("default")
	# Make the animation visible
	slot.visible = true
	slot2.visible = true
	slot3.visible = true
	# Make the results invisible
	result1.visible = false
	result2.visible = false
	result3.visible = false
	
func Slots_End():
	# Pause the slots animation
	slot.pause()
	slot2.pause()
	slot3.pause()
	# Make the animation invisible
	slot.visible = false
	slot2.visible = false
	slot3.visible = false
	# Show the results
	result1.visible = true
	result2.visible = true
	result3.visible = true
	# Enable the play again button
	button.disabled = false

func _on_Replay_pressed() -> void:
	Randomized_Pic()
