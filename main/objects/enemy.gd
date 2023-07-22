extends CharacterBody2D

@export var healthMax:float = 2.0
var currentHealth = healthMax
var dead:bool = false
var speed:float = 50.0
var explodeRange:float = 10.0
var target:Vector2
var rectMax = 50
@onready var hpBar = $healthbarPivot/overHealth

@onready var pivot:Node = $enemyPivot
@onready var director:Node = $enemyPivot/enemyDirector

@onready var indicatorDamage = preload("res://main/objects/DamageIndicator.tscn")
@export var effectHit: PackedScene = null
@export var effectDied: PackedScene = null
@export var value: int = 0

func die():
	dead = true
	$healthbarPivot/explosionSprite.play("explosion")
	$healthbarPivot/enemySpriteLeft.visible = false
	$healthbarPivot/enemySpriteRight.visible = false
	$healthbarPivot/underHealth.visible = false
	$hitbox.set_deferred("disabled", true)
	Stats.add_score(value)
	Stats.add_score(1)
	GV.enemies.erase(self)

func _physics_process(delta):
	if dead: return;
	look_at(target)
	rotation_degrees += 90
	$healthbarPivot.global_rotation = 0
	velocity = (director.global_position - position) * speed
	$healthbarPivot/enemySpriteLeft.visible = false
	$healthbarPivot/enemySpriteRight.visible = false
	if velocity.x > 0: $healthbarPivot/enemySpriteRight.visible = true
	else: $healthbarPivot/enemySpriteLeft.visible = true
	move_and_slide()

func damage(amt:float):
	currentHealth -= amt
	hpBar.set_size(Vector2((currentHealth/healthMax) * rectMax, 5))
	$healthbarPivot/underHealth.visible = true
	$healthbarPivot/overHealth.visible = true
	if currentHealth <= 0.0: die();
	else: $knockbackAnim.play("knockback");
	spawnEffect(effectHit)
	spawnDmgIndicator(amt)

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
