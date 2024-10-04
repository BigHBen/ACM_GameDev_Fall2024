extends Sprite2D

var velocity = Vector2.DOWN * 100  # adjust speed
var initial_pos = Vector2.ZERO

func _ready():
	initial_pos = self.position

func _process(delta):
	position += velocity * delta
	if position.y >= initial_pos.y+20:
		velocity = Vector2.ZERO
