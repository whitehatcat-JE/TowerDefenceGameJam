extends CharacterBody2D

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
	if position.distance_to(target) < explodeRange:
		die()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
