extends CharacterBody2D

@export var health:float = 2.0

var speed:float = 50.0
var explodeRange:float = 10.0
var target:Vector2

@onready var pivot:Node = $enemyPivot
@onready var director:Node = $enemyPivot/enemyDirector

func die():
	queue_free()

func _physics_process(delta):
	pivot.look_at(target)
	pivot.rotation_degrees += 90
	velocity = (director.global_position - position) * speed
	move_and_slide()

func damage(amt:float):
	health -= amt
	if health <= 0.0:
		die()
