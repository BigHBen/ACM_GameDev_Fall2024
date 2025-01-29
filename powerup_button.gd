extends Panel


var powerup_name = "Freeze_Slot"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($Powerup.text)
	$Powerup.set_text(powerup_name)
	print($Powerup.get_text())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_powerup_button_down() -> void:
	print("%s" % powerup_name)
