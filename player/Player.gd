extends CharacterBody2D

#Hurt effect when done
#const playerhurt = preload("res://")
#States
enum {
	MOVE,
	ATTACK
}
#All The Variables needed throughout the code
var acceleration = 1000
var maxSpeed = 220
var friction = 1700

var state = MOVE

#onready var ap = $AnimationPlayer
#onready var at = $AnimationTree
#onready var ans = at.get("parameters/playback")
#onready var sh = $hitbox/Hitbox


#runs every frame to load which ever state has been most recently called
func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)

#Move state has all move functions
func move_state(delta):
	var ip = Vector2.ZERO
#	(Left - Right) + (up - Down) Equals direction of travel,
# Nomalized stops the diagonal from being longer than normal
	ip.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	ip.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	ip = ip.normalized()
	
	if ip != Vector2.ZERO:
		#sh.kbv = ip
#		loading animations
		#at.set("parameters/idle/blend_position", ip)
		#at.set("parameters/Run/blend_position", ip)
		#at.set("parameters/Attack/blend_position", ip)
		#ans.travel("Run")
		velocity = velocity.move_toward(ip * maxSpeed, acceleration * delta)
	else: 
		#ans.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move()
	
	if Input.is_action_just_pressed("attack"):
		print("attack")
		state = ATTACK

#simple attack state
 #warning-ignore:unused_argument
func attack_state(delta):
	velocity = Vector2.ZERO
	$SwordHitbox/Hitbox.set_deferred("monitoring", true)
	await get_tree().create_timer(0.25).timeout
	#ans.travel("Attack")
	state = MOVE

func move():
	move_and_slide()
