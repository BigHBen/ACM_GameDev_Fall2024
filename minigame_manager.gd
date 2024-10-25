extends Node2D


var winning_bet = 0 : set = set_winning_bet, get = get_winning_bet

func set_winning_bet(value):
	winning_bet = value

func get_winning_bet():
	return winning_bet
