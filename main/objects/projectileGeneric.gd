extends Area2D

var speed:float = 200.0
var explodeRange:float = 10.0
var target:Vector2

@onready var director:Node = %director

func die():
	queue_free()

func _physics_process(delta):
	look_at(target)
	rotation_degrees += 90
	position += (director.global_position - position) * speed * delta
	if position.distance_to(target) < explodeRange:
		die()

func _on_body_entered(body):
	die()

func _on_timer_timeout():
	die()