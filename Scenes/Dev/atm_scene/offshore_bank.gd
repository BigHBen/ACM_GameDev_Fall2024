extends Node2D

#Spinbox limits
@export var max_transaction_amount : int = 1000

#Scenes
@onready var currency_manager : CurrencyManager = get_node("/root/CurrencyManager")
var casino ="res://Scenes/casino.tscn"

#Entry boxes
@onready var deposit_entry : SpinBox = $UI/MenuPanel/VBoxContainer/DepositBox/deposit_entry
@onready var withdraw_entry : SpinBox = $UI/MenuPanel/VBoxContainer/WithdrawBox/withdraw_entry

#Buttons
@onready var deposit_button : Button = $UI/MenuPanel/VBoxContainer/DepositBox/Deposit
@onready var withdrawal_button : Button = $UI/MenuPanel/VBoxContainer/WithdrawBox/Withdrawal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deposit_entry.max_value = max_transaction_amount
	withdraw_entry.max_value = max_transaction_amount
	deposit_button.pressed.connect(_on_button_pressed.bind(deposit_button))
	withdrawal_button.pressed.connect(_on_button_pressed.bind(withdrawal_button))
	print("Welcome to Offshore Bank Account! (Dev Only)")

func process_transaction(action: String, amount: float) -> void:
	print(action, " : Old Balance: $", currency_manager.get_balance())
	currency_manager.set_balance(currency_manager.get_balance() + int(amount))
	print(action, " : New Balance: $", currency_manager.get_balance())

func _on_game_exit_button_down() -> void:
	get_tree().change_scene_to_file(casino)

func _on_button_pressed(button_pressed: Button):
	match button_pressed:
		deposit_button: 
			process_transaction("Deposit", deposit_entry.value)
		withdrawal_button:
			process_transaction("Withdrawal", -withdraw_entry.value)
