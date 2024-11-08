extends Node2D

# Variables
var balance : int = 0 : set = set_balance, get = get_balance
var curr_round : int = 0 : set = set_round, get = get_round

signal currency_manager_loaded

func _ready() -> void:
	#balance = 100
	currency_manager_loaded.emit()

# Setters
func set_balance(value: int) -> void:
	balance = max(0, value)

# Getters
func get_balance() -> int:
	return balance

func set_round(value):
	curr_round = value

func get_round():
	return curr_round
