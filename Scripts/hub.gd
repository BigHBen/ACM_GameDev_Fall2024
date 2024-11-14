extends Node2D


#Scene Transfer
var casino = "res://Scenes/casino.tscn" #Minigame select scene

#Global variable initialization
@onready var minigame_manager = get_node("/root/MinigameManager")
@onready var currency_manager = get_node("/root/CurrencyManager")

#Player starts game w/ small amount 
#IDEA - Use Sington - Global access to currency related variables
#var bill_amount : int
#var current : int

#Round variables
var round_number: int = 0

@export var INITIAL_BALANCE = 20
var initial_bill: int = 20
var bill_increment: int = 10
var current_bill: int = 0 : set = set_bill_amount, get = get_bill_amount
@export_range(1,120) var casino_time : int = 30
@onready var GAME_TIMER : Timer = get_node("/root/CasinoTimer")

#Button Variables
@onready var menu_anim = $UI/MenuButtons/AnimationPlayer

#Audio
@onready var audio_player = $Audio/pay_button
@onready var audio_player2 = $Audio/leave_home

var sound_effects = {
	"pay": preload("res://Audio/cha ching sound effect download.wav"),
	"insufficient": preload("res://Audio/Wrong sound effect.mp3")
}

#Label Variables
@onready var day_label = $UI/VBoxContainer/Day
@onready var bill_amount_label = $UI/VBoxContainer/BillAmount
@onready var balance_label = $UI/VBoxContainer/Current
@onready var return_label = $UI/VBoxContainer/Return

#Popup Effect Variables
var scale_amount = 1.0
var scale_speed = 0.25

# At the start of each round, add casino winnings to player balance
func _ready() -> void:
	round_number = currency_manager.curr_round
	if round_number > 0:
		accumulate_winnings()
	start_round()

func accumulate_winnings():
	var new_balance = currency_manager.balance + minigame_manager.get_winning_bet()
	currency_manager.set_balance(new_balance)
	print("Earnings from casino: $%s"  % [minigame_manager.get_winning_bet()])

#Present player with new bill amount and update labels accordingly
func start_round() -> void:
	
	# First round setup
	if round_number < 1:
		currency_manager.set_balance(INITIAL_BALANCE)  # Initialize player balance
	
	round_number += 1  # Increment round number
	
	#Retrieve unpaid bill(s) (from past rounds)
	current_bill = currency_manager.debt
	
	# Calculate current bill
	var temp_cur_bill = initial_bill + (round_number - 1) * bill_increment 
	current_bill += temp_cur_bill
	
	# Update UI
	day_label.text = "Day %d" % round_number
	balance_label.text = "Balance: $%d" % currency_manager.balance
	
	# Print round info
	print("\nWelcome back home!")
	print("Round %d: Bill -> \n     Past Bills (Debt): $%d + New: $%d -> Total: $%d" % \
	[round_number, currency_manager.debt, temp_cur_bill, current_bill])

	# Load UI animation
	$UI/AnimationPlayer.play("popup")
	
	# Update currency manager
	currency_manager.set_round(round_number)

#If player presses play button or makes payment -> Go to Casino
func go_to_casino():
	var door_close_sound_range = 2.75
	
	return_label.text = "Going to casino...."
	menu_anim.play("move_scene")
	audio_player2.play(4.5)
	
	await get_tree().create_timer(door_close_sound_range).timeout
	audio_player2.stop()
	
	#IMPORTANT - Start global timer - Player has (30) seconds to play minigames 
	#After timer elapsed, send player back to hub scene
	
	#Set debt (remaining bill amount) before leaving
	currency_manager.set_debt(current_bill)
	
	#Reset minigame count
	minigame_manager.minigame_count = 0
	
	#Change scene to casino
	get_tree().change_scene_to_file(casino)
	
	#Start casino timer
	GAME_TIMER.start_timer(casino_time) 


func pay_debt():
	var old_balance = currency_manager.balance
	var old_bill = current_bill

	# Calculate new balance and new bill
	var new_balance = currency_manager.balance - current_bill
	current_bill = max(0, current_bill - currency_manager.balance)

	# Update currency manager balance
	currency_manager.set_balance(new_balance)

	# Update balance label
	balance_label.text = "Balance: $%d" % new_balance

	# Print debt payment details
	print("\nYou paid off debt! \n     Debt: $%d -> $%d | Balance: $%d -> $%d" % \
	[old_bill, current_bill, old_balance, new_balance])

#Bill amount setter/getter
func set_bill_amount(value):
	current_bill = value
	bill_amount_label.text = "You Owe: $" + str(current_bill)

func get_bill_amount():
	return current_bill

#region Buttons

#If player has enough $$$ -> skip round
func _on_pay_bills_pressed() -> void:
	if currency_manager.balance >= current_bill:
		audio_player.stream = sound_effects['pay']
		audio_player.play(0.3)
		pay_debt()
		go_to_casino()
	else:
		print("$%s short.. - Earn more at the casino!" % [current_bill-currency_manager.balance])
		menu_anim.play("button_shake")
		audio_player.stream = sound_effects['insufficient']
		audio_player.play(0.5)

#GO TO CASINO
func _on_start_button_pressed() -> void:
	go_to_casino()

#Exit round -> To main menu
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_to_shop_pressed() -> void:
	print("Shop - Purchase Companions (To-Do)")
	#get_tree().change_scene_to_file(shop)
#endregion
