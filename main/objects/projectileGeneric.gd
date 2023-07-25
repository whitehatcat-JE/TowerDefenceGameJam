extends Area2D

@export var speed:float = 200.0
var explodeRange:float = 10.0
var damageAmt:int = 1
var target:Vector2
var dead = false

@onready var director:Node = %director

func die():
	dead = true
	$explosionParticles.emitting = true
	$projectileGenericTemp.visible = false
	$killTimer.start()

func _physics_process(delta):
	if dead: return;
	look_at(target)
	rotation_degrees += 90
	position += (director.global_position - position) * speed * delta

func _on_body_entered(body):
	if dead: return;
	if body.has_method("damage"):
		body.damage(damageAmt)
	die()

func _on_timer_timeout():
	die()

func _on_kill_timer_timeout():
	queue_free()
