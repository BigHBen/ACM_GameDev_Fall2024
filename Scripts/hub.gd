extends Node2D


#Scene Transfer
var casino = "res://Scenes/casino.tscn" #Minigame select scene

#Player starts game w/ small amount 
#IDEA - Use Sington - Global access to currency related variables
var bill_amount : int = 1000
var current : int = 2

#Popup Effect Variables
var scale_amount = 1.0
var scale_speed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale = Vector2(0, 0)  # Initialize scale to 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.scale = self.scale.move_toward(Vector2(scale_amount, scale_amount), delta / scale_speed)
	#$Node2D/BillAmount.text = "You Owe: " + str(bill_amount)
	pass

#If player has enough $$$ -> skip round
func _on_pay_bills_pressed() -> void:
	if current >= bill_amount:
		bill_amount -= current
		get_tree().change_scene_to_file(casino)
	else:
		print("$%s short.. - Earn more at the casino!" % [bill_amount-current])

#Go to Casino
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(casino)

#Exit round -> To main menu
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_to_shop_pressed() -> void:
	print("Shop - Purchase Companions (To-Do)")
	#get_tree().change_scene_to_file(shop)
