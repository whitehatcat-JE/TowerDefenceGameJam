extends CharacterBody2D

#All The Variables needed throughout the code
var acceleration = 1000
var maxSpeed = 220
var friction = 1700

var attacking:bool = false

#runs every frame to load which ever state has been most recently called
func _process(delta):
	var ip = Vector2.ZERO
#	(Left - Right) + (up - Down) Equals direction of travel,
# Nomalized stops the diagonal from being longer than normal
	ip.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	ip.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	ip = ip.normalized()
	
	if ip != Vector2.ZERO:
		velocity = velocity.move_toward(ip * maxSpeed, acceleration * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if velocity.x > 0:
		$playerSprite.scale.x = -0.5
	elif velocity.x < 0:
		$playerSprite.scale.x = 0.5
	move()
	
	if Input.is_action_just_pressed("attack") and !attacking:
		attack()

func attack():
	attacking = true
	$playerSprite.play("attack")
	$SwordHitbox/Hitbox.set_deferred("monitoring", true)
	await get_tree().create_timer(0.5).timeout
	$SwordHitbox/Hitbox.set_deferred("monitoring", false)
	$playerSprite.play("idle")
	attacking = false

func move():
	move_and_slide()
