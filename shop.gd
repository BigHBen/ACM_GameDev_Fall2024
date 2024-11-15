extends Node2D


var powerups  = {
	"Freeze_Slot" : 1,
	"Double_Time" : 2,
	"Double_Money": 3
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Welcome to the Shop!")
	load_powerups()


#On start, load 3 random powerups from array
#Player can purchase powerups and use them in current round
#Shop reset every round
func load_powerups():
	#print(powerups[randi_range(1,3)])
	#print(powerups["Freeze_Slot"])
	#print(powerups)
	$UI/Panel/Label.text 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
