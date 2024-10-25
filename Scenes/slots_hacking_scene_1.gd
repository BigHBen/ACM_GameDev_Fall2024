extends Node2D

#creates variable for animation player
@onready var AP = $AnimationPlayer
var position = 53

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 #when this part starts, the right block will move
	while(!_on_stop_button_pressed()):
		if (position == 350):
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_stop_button_pressed() -> void:
	
	return true
