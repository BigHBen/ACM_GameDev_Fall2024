extends Node2D

var Bet = 10
var win = 0

@export var tries = 3 : set=set_tries, get=get_tries

# Variables for nodes in scene
@onready var button: Button = $Control/Button
@onready var slot: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot
@onready var slot2: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot2
@onready var slot3: AnimatedSprite2D = $Control/Panel/HBoxContainer/Animation/Slot3
@onready var result1: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot_pic
@onready var result2: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot2_pic
@onready var result3: Sprite2D = $Control/Panel/HBoxContainer/Results/Slot3_pic

#variable for which slot and object is frozen
var freeze
var slot1_res
var slot2_res
var slot3_res

#Hilton - Added win screen
#Hilton - Bet is loaded from menu

@export var slot_spin_time : float = 3.0

@onready var minigame_manager = get_node("/root/MinigameManager")
var won = false
var your_bet #From minigame_manager
var WIN_AMOUNT : int = 0# Changes player balance
@onready var win_anim = $WinPanel/AnimationPlayer
@onready var finish_timer = $FinishTimer
@onready var winnings_label = $WinPanel/HBoxContainer/Winnings
@onready var return_label = $WinPanel/HBoxContainer/Return
@onready var spin_label = $Control/Spins_Count
var casino = "res://Scenes/casino.tscn"

# By the way you can edit the animation that plays in the slot_animation scene
# Main use for editing is increasing or decreasing the frames per second in order to change how fast the animation plays
# Experiment with different values to see what looks nice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	your_bet = minigame_manager.get_slots_bet_info()
	
	if (MinigameManager.get_powerup("Freeze_Slot") != null && MinigameManager.get_powerup("Freeze_Slot")[1] == true):
		slot1_res = randi_range(0,3)
		slot2_res = randi_range(0,3)
		slot3_res = randi_range(0,3)
		Slots_Results(result1, slot1_res)
		Slots_Results(result2, slot2_res)
		Slots_Results(result3, slot3_res)
		$FreezePanel.visible = true
	else:
		#Automatically starts first spin if freeze slot not used
		tries -= 1
		Randomized_Pic()
	
	
func Randomized_Pic():
	# Calculate what each slot landed on to be used in later functions
	var slot1_result = slot1_res
	var slot2_result = slot2_res
	var slot3_result = slot3_res
	match freeze:
		1:
			slot2_result = randi_range(0,3)
			slot3_result = randi_range(0,3)
			pass
		2:
			slot1_result = randi_range(0,3)
			slot3_result = randi_range(0,3)
			pass
		3:
			slot1_result = randi_range(0,3)
			slot2_result = randi_range(0,3)
			pass
		_:
			slot1_result = randi_range(0,3)
			slot2_result = randi_range(0,3)
			slot3_result = randi_range(0,3)
			pass
	
	# Hides the results and shows the slots animation.
	# Also temporarily removes the play button to prevent multiple inputs
	Slots_Start()
	# Lets the animation play for 3 seconds for finalizing and letting the rest of the code play.
	await get_tree().create_timer(slot_spin_time).timeout
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
		won = true
		finish_timer.start()
		$WinPanel/HBoxContainer/Title.text = "YOU WIN"
		win_anim.play("popup")
	else:
		print("You Lost!")
		
		#Set up lose popup and return to casino
		if tries == 0:
			won = false
			finish_timer.start()
			$WinPanel/HBoxContainer/Title.text = "YOU LOSE 😿"
			win_anim.play("popup")
	return winnings

func Slots_Start():
	print("You have %d tries left" % tries)
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
	if tries >= 0:
		Randomized_Pic()
		tries -= 1
	else:
		won = false
		finish_timer.start()
		$WinPanel/HBoxContainer/Title.text = "YOU LOSE :("
		win_anim.play("popup")


func score_announced():
	pass

func _process(_delta: float) -> void:
	if !finish_timer.is_stopped():
			update_return_label()

func update_return_label():
	var remaining_time = int(finish_timer.time_left) + 1
	if remaining_time < 4 && remaining_time > 0: 
		return_label.text = "Returning to casino (%d)...." % remaining_time

func set_tries(value):
	tries = value
	spin_label.text = "SPINS LEFT: %d" % tries

func get_tries():
	return tries
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "popup":
		winnings_label.score_announced.connect(score_announced)
		if your_bet:
			if won:
				#Will be passed to minigame manager -> Added to player balance
				WIN_AMOUNT = your_bet["amount"]
				
				winnings_label.start_effect(your_bet["amount"])
				#$Audio/win_result.play()
			else:
				
				#Will be passed to minigame manager -> Added to player balance
				WIN_AMOUNT = -your_bet["amount"]
				
				winnings_label.start_effect(-your_bet["amount"])
				#$Audio/lose_result.play()
				#await get_tree().create_timer(1.25).timeout
				#$Audio/lose_result2.play()
			
			minigame_manager.set_winning_bet(minigame_manager.winning_bet + WIN_AMOUNT)
			#CurrencyManager.set_balance(CurrencyManager.get_balance()+WIN_AMOUNT)
			
		else:
			winnings_label.start_effect(0)


func _on_finish_timer_timeout() -> void:
	return_label.text = "Returning to casino (0)...."
	minigame_manager.minigame_count += 1
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(casino)


func _on_button_1_pressed() -> void:
	freeze = 1
	$FreezePanel.visible = false
	Randomized_Pic()
	tries = 2
	


func _on_button_2_pressed() -> void:
	freeze = 2
	$FreezePanel.visible = false
	Randomized_Pic()
	tries = 2


func _on_button_3_pressed() -> void:
	freeze = 3
	$FreezePanel.visible = false
	Randomized_Pic()
	tries = 2
