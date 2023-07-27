extends CharacterBody2D

signal plrAttack

#All The Variables needed throughout the code
var acceleration = 5000
var maxSpeed = 350
var friction = 5000

var attacking:bool = false
var hasHit:bool = false

#runs every frame to load which ever state has been most recently called
func _process(delta):
	GV.curPlayerLoc = global_position
	var ip = Vector2.ZERO
#	(Left - Right) + (up - Down) Equals direction of travel,
# Nomalized stops the diagonal from being longer than normal
	ip.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	ip.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	ip = ip.normalized()
	
	if ip != Vector2.ZERO:
		velocity = velocity.move_toward(ip * maxSpeed, acceleration * delta)
		if $playerSprite.animation == "idle":
			$playerSprite.play("walk")
		if $footstepTimer.is_stopped(): _on_footstep_timer_timeout();
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		if $playerSprite.animation == "walk":
			$playerSprite.play("idle")
		if !$footstepTimer.is_stopped(): $footstepTimer.stop();

	if velocity.x > 0:
		$playerSprite.scale.x = 0.5
	elif velocity.x < 0:
		$playerSprite.scale.x = -0.5
	move()
	
	if Input.is_action_just_pressed("attack") and !attacking:
		attack()

func attack():
	attacking = true
	$attackAnim.play("attack")
	$playerSprite.play("attack")
	$playerSprite/attackSprite.play("sweep")
	hasHit = false
	await get_tree().create_timer(0.1).timeout
	if hasHit:
		get_node("attackHitSFX" + str(randi_range(1, 5))).play()
	else:
		get_node("attackSFX" + str(randi_range(1, 3))).play()

func move():
	if attacking:
		var tempVel = velocity
		velocity *= 0.75
		move_and_slide()
		velocity = tempVel
	else:
		move_and_slide()

func _on_player_sprite_frame_changed():
	if $playerSprite.animation == "attack" and $playerSprite.frame == 1:
		emit_signal("plrAttack")

func _on_xp_collision_field_area_entered(area):
	area.queue_free()
	if area.type == "xp":
		GV.xp += 1
		Stats.add_score(1)
		get_node("xpSFX" + str(randi_range(1, 2))).play()
	elif GV._health < GV.startingHealth:
		GV._health += 1

func _on_attack_field_hit_enemy():
	hasHit = true


func _on_player_sprite_animation_finished():
	if $playerSprite.animation == "attack":
		$playerSprite.play("idle")
		$playerSprite/attackSprite.play("idle")
		attacking = false


func _on_footstep_timer_timeout():
	get_node("footstepSFX" + str(randi_range(1, 5))).play()
	$footstepTimer.start()
