extends Node2D

var speed: int = 30
var friction: int = 15
var shiftDiection: Vector2 = Vector2.ZERO

@onready var label = $Label

func _ready():
	shiftDiection = Vector2(randf_range(-1, 1), randf_range(-1, 1))

func _process(delta):
	global_position += speed * shiftDiection * delta
	speed = max(speed - friction * delta, 0)
