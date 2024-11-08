extends Node2D


#Scene Transfer
var casino = "res://Scenes/casino.tscn" #Minigame select scene
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

#Label Variables
@onready var day_label = $UI/VBoxContainer/Day
@onready var bill_amount_label = $UI/VBoxContainer/BillAmount
@onready var balance_label = $UI/VBoxContainer/Current

#Popup Effect Variables
var scale_amount = 1.0
var scale_speed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(0, 0)  # Initialize scale to 0
	start_round()

#On round start, present player with new bill amount and update labels accordingly
func start_round() -> void:
	
	#First round
	if round_number < 1:
		currency_manager.set_balance(10) #Start player off with 10 dollars
	
	round_number += 1
	current_bill = initial_bill + (round_number - 1) * bill_increment
	
	day_label.text = "Day " + str(round_number)
	balance_label.text = "$" + str(currency_manager.balance)
	print("Round ", round_number, ": Bill = $", current_bill)

func _process(delta: float) -> void:
	self.scale = self.scale.move_toward(Vector2(scale_amount, scale_amount), delta / scale_speed)
	#$Node2D/BillAmount.text = "You Owe: " + str(bill_amount)
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
	print(current_bill, " ", currency_manager.balance)
	if currency_manager.balance >= current_bill:
		current_bill -= currency_manager.balance
		get_tree().change_scene_to_file(casino)
	else:
		print("$%s short.. - Earn more at the casino!" % [current_bill-currency_manager.balance])

#Go to Casino
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(casino)

#Exit round -> To main menu
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_to_shop_pressed() -> void:
	print("Shop - Purchase Companions (To-Do)")
	#get_tree().change_scene_to_file(shop)
#endregion
