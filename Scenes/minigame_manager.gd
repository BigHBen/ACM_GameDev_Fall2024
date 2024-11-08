extends Node2D

var current_scene = null

#Horse racing variables
var horse_bet = {} : set = set_horse_bet_info, get = get_horse_bet_info
var horse_names = []

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func set_horse_bet_info(value):
	horse_bet["horse"] = value[0]
	horse_bet["amount"] = value[1]

func get_horse_bet_info():
	return horse_bet

func set_horse_bet(h_name):
	horse_bet["horse"] = h_name
	print("You've chosen %s" % [horse_bet["horse"]])

func set_horse_bet_amount(value):
	horse_bet["amount"] = value
	print("💸 Bet Amount: $", horse_bet["amount"], "💰")

func set_horse_names(array):
	horse_names = array
