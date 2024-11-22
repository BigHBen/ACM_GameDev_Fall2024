extends Node2D

@onready var minigame_manager = get_node("/root/MinigameManager")
@onready var Currecy_Manager = get_node("/root/CurrencyManager")
var first_power
var second_power
var third_power

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Welcome to the Shop!")
	load_powerups()


#On start, load 3 random powerups from array
#Player can purchase powerups and use them in current round
#Shop reset every round
func load_powerups():
	var size = minigame_manager.get_size_powerup()
	first_power = randi_range(0,size-1)
	$"UI 2/HBoxContainer/VBoxContainer/first_power".text = minigame_manager.get_powerup(first_power)[0]
	$"UI 2/HBoxContainer/VBoxContainer/price1".text = str("Price: ", minigame_manager.get_powerup(first_power)[2])
	
	second_power = randi_range(0,size-1)
	while (second_power == first_power):
		second_power = randi_range(0,size-1)
	$"UI 2/HBoxContainer/VBoxContainer2/second_power".text = minigame_manager.get_powerup(second_power)[0]
	$"UI 2/HBoxContainer/VBoxContainer2/price2".text = str("Price: ", minigame_manager.get_powerup(second_power)[2])
	
	third_power = randi_range(0,size-1)
	while (third_power == second_power || third_power == first_power):
		third_power = randi_range(0,size-1)
	$"UI 2/HBoxContainer/VBoxContainer3/third_power".text = minigame_manager.get_powerup(third_power)[0]
	$"UI 2/HBoxContainer/VBoxContainer3/price3".text = str("Price: ", minigame_manager.get_powerup(third_power)[2])
	
func _process(delta: float) -> void:
	pass



func _on_first_power_pressed() -> void:
	if(minigame_manager.get_powerup(first_power)[2] <= Currecy_Manager.get_balance()):
		if (minigame_manager.get_powerup(first_power)[1] == false):
			minigame_manager.get_powerup(first_power)[1] = true
		else:
			$already_bought.visible = true
			await get_tree().create_timer(1).timeout
			$already_bought.visible = false
	else:
		$insufficient.visible = true
		await get_tree().create_timer(1).timeout
		$insufficient.visible = false


func _on_second_power_pressed() -> void:
	if(minigame_manager.get_powerup(second_power)[2] <= Currecy_Manager.get_balance()):
		if (minigame_manager.get_powerup(second_power)[1] == false):
			minigame_manager.get_powerup(second_power)[1] = true
		else:
			$already_bought.visible = true
			await get_tree().create_timer(1).timeout
			$already_bought.visible = false
	else:
		$insufficient.visible = true
		await get_tree().create_timer(1).timeout
		$insufficient.visible = false


func _on_third_power_pressed() -> void:
	if(minigame_manager.get_powerup(third_power)[2] <= Currecy_Manager.get_balance()):
		if (minigame_manager.get_powerup(third_power)[1] == false):
			minigame_manager.get_powerup(third_power)[1] = true
		else:
			$already_bought.visible = true
			await get_tree().create_timer(1).timeout
			$already_bought.visible = false
	else:
		$insufficient.visible = true
		await get_tree().create_timer(1).timeout
		$insufficient.visible = false
		

func _on_leave_pressed() -> void:
	var rnd = Currecy_Manager.get_round()
	Currecy_Manager.set_round(rnd-1)
	get_tree().change_scene_to_file("res://Scenes/hub.tscn")
