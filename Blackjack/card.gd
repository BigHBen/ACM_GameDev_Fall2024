extends Control

@export var  val = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Change the button when the mouse enters (hover effect)
# Revert changes when the mouse leaves
func _on_Mouse_Exited():
	modulate = Color(1, 1, 1)  # Reset color to default (white)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_mouse_entered() -> void:
	scale = Vector2(1.2, 1.2)  # Increase size when hovered
	print("GAHGA")
 # Replace with function body

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)  # Reset size when the mouse leaves
	("OOOF OW OOF MY BONES")
