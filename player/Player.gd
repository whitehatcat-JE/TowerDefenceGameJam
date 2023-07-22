extends CharacterBody2D

signal plrAttack

#All The Variables needed throughout the code
var acceleration = 2000
var maxSpeed = 300
var friction = 2000

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
		$playerSprite.scale.x = 0.5
	else:
		$playerSprite.scale.x = -0.5
	move()
	
	if Input.is_action_just_pressed("attack") and !attacking:
		attack()

func attack():
	attacking = true
	$attackAnim.play("attack")
	$playerSprite.play("attack")
	$playerSprite/attackSprite.play("sweep")
	await get_tree().create_timer(0.5).timeout
	$playerSprite.play("idle")
	$playerSprite/attackSprite.play("idle")
	attacking = false

func move():
	move_and_slide()

func _on_player_sprite_frame_changed():
	if $playerSprite.animation == "attack" and $playerSprite.frame == 1:
		emit_signal("plrAttack")
