extends Control

@export var shoeSize = 1;
var can_act = true
var money = 25

var timer 
var bet = 0
var hand_locations = [$Dealer_pos, $Hand_pos1, $Hand_pos2, $Hand_pos3, $Hand_pos4]


var card_prefab = preload("res://Blackjack/card.tscn")
var path_to_cards = "res://Assets/Packs/Top-Down/cropped_cards/"

var deck = [
	["Ace", "Clubs", "c (1).png"], [2, "Clubs", "c (2).png"], [3, "Clubs", "c (3).png"], [4, "Clubs", "c (4).png"], [5, "Clubs", "c (5).png"], [6, "Clubs", "c (6).png"], [7, "Clubs", "c (7).png"], [8, "Clubs", "c (8).png"], [9, "Clubs", "c (9).png"], [10, "Clubs", "c (10).png"], ["Jack", "Clubs", "c (11).png"], ["Queen", "Clubs", "c (12).png"], ["King", "Clubs", "c (13).png"],
	["Ace", "Diamonds", "d (1).png"], [2, "Diamonds", "d (2).png"], [3, "Diamonds", "d (3).png"], [4, "Diamonds", "d (4).png"], [5, "Diamonds", "d (5).png"], [6, "Diamonds", "d (6).png"], [7, "Diamonds", "d (7).png"], [8, "Diamonds", "d (8).png"], [9, "Diamonds", "d (9).png"], [10, "Diamonds", "d (10).png"], ["Jack", "Diamonds", "d (11).png"], ["Queen", "Diamonds", "d (12).png"], ["King", "Diamonds", "d (13).png"],
	["Ace", "Hearts", "h (1).png"], [2, "Hearts", "h (2).png"], [3, "Hearts", "h (3).png"], [4, "Hearts", "h (4).png"], [5, "Hearts", "h (5).png"], [6, "Hearts", "h (6).png"], [7, "Hearts", "h (7).png"], [8, "Hearts", "h (8).png"], [9, "Hearts", "h (9).png"], [10, "Hearts", "h (10).png"], ["Jack", "Hearts", "h (11).png"], ["Queen", "Hearts", "h (12).png"], ["King", "Hearts", "h (13).png"],
	["Ace", "Spades", "s (1).png"], [2, "Spades", "s (2).png"], [3, "Spades", "s (3).png"], [4, "Spades", "s (4).png"], [5, "Spades", "s (5).png"], [6, "Spades", "s (6).png"], [7, "Spades", "s (7).png"], [8, "Spades", "s (8).png"], [9, "Spades", "s (9).png"], [10, "Spades", "s (10).png"], ["Jack", "Spades", "s (11).png"], ["Queen", "Spades", "s (12).png"], ["King", "Spades", "s (13).png"]
]
var shoe = []

var score = [[],[],[],[],[]]

func ace_array(hand: Array, curr_sum:int) -> Array:
	for card in hand:
		if curr_sum < 22:
			return hand
		if card == 11:
			card = 1
	return hand

func instantiate_Card(card: Array, seat: int) -> void:
	var val = card [0]
	var suit = card[1]
	var pic = card[2]  
	var loaded_card = card_prefab.instantiate()
	print("trying" + str(card))
	loaded_card.get_child(0).set_texture(load(path_to_cards + pic))
	add_child(loaded_card)
	score[seat].append(val)
	var points = 0
	var hand = []
	for card_value in score[seat]:
		if str(card_value) != "Ace":
			if str(card_value) == "Jack" or str(card_value) == "Queen" or str(card_value) == "King":
				points += 10  # Add 10 points for Jack, Queen, or King
				
			else:
				points += int(card_value)  # Convert the numeric value to an integer and add to points
		else:
		# Handle the Ace logic
			if points + 11 <= 21:
				hand.append(11)  # Add 11 for Ace
			else:
				hand.append(1)   # Add 1 for Ace
	for i in hand:
		if points < 11:
			
	print(points)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoe = deck
	for i in range(0,shoeSize):
		shoe = shoe + deck
	shoe.shuffle()
	timer = $bet_clock
	instantiate_Card(shoe.pop_front(), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !timer.is_stopped() and can_act == false:
		can_act = true 



func _input(event: InputEvent) -> void:
	if !can_act:
		return
	if event.is_action_pressed("ui_accept"):
		bet += 5
	if event.is_action_pressed("ui_cancel"):
		bet -= 5
	if event.is_action_pressed("hit"):
		instantiate_Card(shoe.pop_front(),0)
	
		
	
