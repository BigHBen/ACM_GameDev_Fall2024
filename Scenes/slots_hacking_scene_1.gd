extends Node2D

#creates variable for animation player
@onready var AP = $AnimationPlayer
var Xposition = 956
var speed = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 #when this part starts, the right block will move
	AP.play("moving_block")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_on_stop_button_pressed()
func _on_stop_button_pressed() -> void:
	#stops up and down animation
	AP.stop(true)
	#moves moving block over to the input block
	while(Xposition >= 492):
		Xposition = Xposition - speed;
		$Polygon_moving.position.x = Xposition;
		await get_tree().create_timer(.0001).timeout
	#Checks to see if within area in terms of Y axis
	if ($Polygon_moving.position.y >= 140 and $Polygon_moving.position.y<=165):
		#if it is within, the stop button is taken away, a win label explaining
		#that the person won and sends them to the slots minigame
		$"win_Label".visible = true
		$stop_Button.visible = false
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Scenes/slot/slots_game.tscn")
	else:
		#if it is not within, the stop button is taken away, a lose label explaining
		#that the person lost and sends them to the slots menu to bet again
		$"lose_label".visible = true
		$stop_Button.visible = false
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Scenes/slot/slots_menu.tscn")
