extends Node2D

# Variables
var balance : int = 0 : set = set_balance, get = get_balance
var debt : int = 0 : set = set_debt, get = get_debt
var curr_round : int = 0 : set = set_round, get = get_round
var shop_used : bool = false : set = set_shop_used, get = get_shop_used

signal currency_manager_loaded

func _ready() -> void:
	#balance = 100
	currency_manager_loaded.emit()

# Setters
func set_balance(value: int) -> void:
	#balance = max(0, value)
	balance = value

# Getters
func get_balance() -> int:
	return balance

func set_debt(value: int):
	debt = max(0, value)

func get_debt() -> int:
	return debt

func set_round(value):
	curr_round = value

func get_round():
	return curr_round

func set_shop_used(shop_visited):
	shop_used = shop_visited

func get_shop_used():
	return shop_used
