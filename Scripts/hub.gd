extends Node2D


#Scene Transfer
var casino = "res://Scenes/casino.tscn" #Minigame select scene
@onready var minigame_manager = get_node("/root/MinigameManager")
@onready var currency_manager = get_node("/root/CurrencyManager")

#Player starts game w/ small amount 
#IDEA - Use Sington - Global access to currency related variables
#var bill_amount : int
#var current : int

#Round variables
var round_number: int = 0
var initial_bill: int = 20
var bill_increment: int = 10
var current_bill: int = 0 : set = set_bill_amount, get = get_bill_amount
@onready var GAME_TIMER : Timer = get_node("/root/CasinoTimer")

#Button Variables
@onready var menu_anim = $UI/MenuButtons/AnimationPlayer

#Label Variables
@onready var day_label = $UI/VBoxContainer/Day
@onready var bill_amount_label = $UI/VBoxContainer/BillAmount
@onready var balance_label = $UI/VBoxContainer/Current
@onready var return_label = $UI/VBoxContainer/Return

#Popup Effect Variables
var scale_amount = 1.0
var scale_speed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_number = currency_manager.curr_round
	if round_number > 0:
		accumulate_winnings()
	start_round()
	

#On round start, present player with new bill amount and update labels accordingly
func start_round() -> void:
	
	#First round
	if round_number < 1:
		currency_manager.set_balance(10) #Start player off with 10 dollars
		
	round_number += 1
	current_bill = initial_bill + (round_number - 1) * bill_increment
	
	day_label.text = "Day " + str(round_number)
	balance_label.text = "Balance: $" + str(currency_manager.balance)
	print("Round ", round_number, ": Bill = $", current_bill)
	
	#Load UI
	$UI/AnimationPlayer.play("popup")
	currency_manager.set_round(round_number)

func accumulate_winnings():
	var new_balance = currency_manager.balance + minigame_manager.get_winning_bet()
	currency_manager.set_balance(new_balance)
	print("Earnings from casino: $%s"  % [minigame_manager.get_winning_bet()])

func _process(_delta: float) -> void:
	pass

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
		current_bill -= currency_manager.balance
		get_tree().change_scene_to_file(casino)
	else:
		print("$%s short.. - Earn more at the casino!" % [current_bill-currency_manager.balance])
		menu_anim.play("button_shake")

#Go to Casino
func _on_start_button_pressed() -> void:
	return_label.text = "Going to casino...."
	menu_anim.play("move_scene")
	await get_tree().create_timer(1.0).timeout
	
	#IMPORTANT - Start global timer - Player has 30 seconds to play minigames 
	#After timer elapsed, send player back to hub scene
	
	print("Time left: " , GAME_TIMER.GAME_TIME)
	get_tree().change_scene_to_file(casino)
	GAME_TIMER.start()

#Exit round -> To main menu
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_to_shop_pressed() -> void:
	print("Shop - Purchase Companions (To-Do)")
	#get_tree().change_scene_to_file(shop)
#endregion
