class_name PunchFist
extends Area2D

#Effects
@onready var animator = $PunchAnimator
@onready var hit_label = $HitLabel

var velocity = Vector2.DOWN * 300
var initial_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
	if(position.y >= 500):
		queue_free()
