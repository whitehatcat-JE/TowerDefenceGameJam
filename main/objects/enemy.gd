extends CharacterBody2D

@export var healthMax:float = 2.0
var currentHealth = healthMax

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

func die():
	queue_free()

func _physics_process(delta):
	look_at(target)
	rotation_degrees += 90
	$healthbarPivot.global_rotation = 0
	velocity = (director.global_position - position) * speed
	move_and_slide()

func damage(amt:float):
	currentHealth -= amt
	hpBar.set_size(Vector2((currentHealth/healthMax) * rectMax, 5))
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

func spawnDmgIndicator(damage: int):
	var indicator = spawnEffect(indicatorDamage)
	if indicator:
		indicator.label.text = str(damage)
