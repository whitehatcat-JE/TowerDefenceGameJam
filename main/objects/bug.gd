extends CharacterBody2D
signal spawnXp(Node)
@export var healthMax:float = 3.0
@onready var currentHealth = healthMax
var dead:bool = false
@export var speed:float = 50.0
var target:Vector2
var rectMax = 50
var playerDamaged:bool = false
@export var explodeRange:float = 100.0
@export var xpAmt:int = 1
@export var damageAmt:int = 1
@onready var hpBar = $healthbarPivot/overHealth

@onready var pivot:Node = $enemyPivot
@onready var director:Node = $enemyPivot/enemyDirector

@onready var indicatorDamage = preload("res://main/objects/DamageIndicator.tscn")
@onready var bulletScene = preload("res://main/objects/projectile_Enemy.tscn")
@export var effectHit: PackedScene = null
@export var effectDied: PackedScene = null

func die():
	dead = true
	$bulletTimer.stop()
	$healthbarPivot/explosionSprite.play("explosion")
	$enemySprite.visible = false
	$healthbarPivot/underHealth.visible = false
	$healthbarPivot/overHealth.visible = false
	$hitbox.set_deferred("disabled", true)
	Stats.add_score(xpAmt)
	Stats.add_score(1)
	for xpIdx in range(xpAmt * 5 if playerDamaged else 1):
		GV.xpQueue.append(self.global_position)
	GV.enemies.erase(self)

func _physics_process(delta):
	if dead: return;
	if global_position.distance_to(target) < explodeRange:
		if $bulletTimer.is_stopped():
			$bulletTimer.start()
		return
	look_at(target)
	rotation_degrees += 90
	$healthbarPivot.global_rotation = 0
	velocity = (director.global_position - position) * speed
	move_and_slide()

func damage(amt:float):
	currentHealth -= amt
	hpBar.set_size(Vector2((currentHealth/healthMax) * rectMax, 5))
	$healthbarPivot/underHealth.visible = true
	$healthbarPivot/overHealth.visible = true
	spawnEffect(effectHit)
	spawnDmgIndicator(amt)
	if currentHealth <= 0.0: die();
	else: $knockbackAnim.play("knockback");

func spawnEffect(EFFECT: PackedScene):
	if EFFECT:
		var effect = EFFECT.instantiate()
		get_parent().add_child(effect)
		effect.global_position = global_position
		return effect

func spawnDmgIndicator(dmg: int):
	var indicator = spawnEffect(indicatorDamage)
	if indicator:
		indicator.label.text = str(dmg)

func _on_explosion_sprite_animation_finished():
	queue_free()


func _on_bullet_timer_timeout():
	var newBullet:Node = bulletScene.instantiate()
	get_parent().add_child(newBullet)
	newBullet.global_position = $enemySprite/projectile.global_position
	newBullet.target = target
