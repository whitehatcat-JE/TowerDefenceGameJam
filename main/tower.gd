extends Node2D

signal levelledUp

signal wallsUnlocked
signal railgunUnlocked
signal empUnlocked
signal turretsUnlocked
signal secondaryTurretsUnlocked

signal railgunFired

enum UPGRADES {
	wall,
	emp,
	turrets,
	railgun,
	secondaryTurrets,
	smallHeal
}

@onready var spawnBullet = preload("res://main/objects/projectile_generic.tscn")

var xp_threshold:float = 5.0
var secondBulletUnlocked:bool = false

var unlockedUpgrades:Array[UPGRADES] = []
var upgradeQueue:Array[UPGRADES] = [UPGRADES.turrets, UPGRADES.wall, UPGRADES.secondaryTurrets, UPGRADES.emp, UPGRADES.railgun]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GV.xp >= GV.xpThreshold:
		GV.xp -= GV.xpThreshold
		levelUp()

func levelUp():
	emit_signal("levelledUp")
	GV.xpThreshold += 20
	if len(upgradeQueue) > 0:
		upgradeTower(upgradeQueue.pop_front())
	else:
		upgradeTower(UPGRADES.smallHeal)

func upgradeTower(newUpgrade:UPGRADES):
	unlockedUpgrades.append(newUpgrade)
	match newUpgrade:
		UPGRADES.wall:
			$minigunUpgradeSFX.play()
			GV.startingHealth += 5
			$upgradeAnims.play("walls")
			emit_signal("wallsUnlocked")
		UPGRADES.emp:
			$empUpgradeSFX.play()
			$empAnim.play("emp")
			emit_signal("empUnlocked")
		UPGRADES.turrets:
			$enemyTimer.start()
			$minigunUpgradeSFX.play()
			secondBulletUnlocked = true
			emit_signal("turretsUnlocked")
		UPGRADES.secondaryTurrets:
			$minigunUpgradeSFX.play()
			$enemyTimer.wait_time *= 0.5
			emit_signal("secondaryTurretsUnlocked")
		UPGRADES.railgun:
			$empUpgradeSFX.play()
			$railgunTimer.start()
			emit_signal("railgunUnlocked")
		_:
			GV.startingHealth += 2

func attackEnemy():
	var closestEnemyLocation = Vector2(200000, 200000)
	var secondEnemyLocation = Vector2(200000, 200000)
	
	for enemy in range(len(GV.enemies)):
		if GV.enemies[enemy].global_position.distance_to(global_position) < closestEnemyLocation.distance_to(global_position):
			closestEnemyLocation = GV.enemies[enemy].global_position
		elif GV.enemies[enemy].global_position.distance_to(global_position) < secondEnemyLocation.distance_to(global_position):
			secondEnemyLocation = GV.enemies[enemy].global_position
	if closestEnemyLocation.distance_to(global_position) > 1000: return;
	$shotSFX1.play()
	
	var bullet:Node = spawnBullet.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.target = closestEnemyLocation
	bullet.align_self()
	
	if secondEnemyLocation.distance_to(global_position) > 1000 or !secondBulletUnlocked: return;
	var secondBullet:Node = spawnBullet.instantiate()
	get_parent().add_child(secondBullet)
	secondBullet.global_position = global_position
	secondBullet.target = secondEnemyLocation
	secondBullet.align_self()

func towerHealing():
	if GV.curPlayerLoc.distance_to(global_position) < 100 or true:
		if GV.get_health() != GV.startingHealth:
			GV.change_health(1)

func _on_railgun_timer_timeout():
	var closestEnemyLocation = Vector2(200000, 200000)
	
	for enemy in range(len(GV.enemies)):
		if GV.enemies[enemy].global_position.distance_to(global_position) < closestEnemyLocation.distance_to(global_position):
			closestEnemyLocation = GV.enemies[enemy].global_position
	if closestEnemyLocation.distance_to(global_position) > 10000: return;
	var curRot:float = $railgunAttack.rotation
	$railgunAttack.look_at(closestEnemyLocation)
	var newRot:float = $railgunAttack.rotation
	$railgunAttack.rotation = curRot
	var rotTween:Tween = get_tree().create_tween()
	rotTween.tween_property($railgunAttack, "rotation", newRot, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	$railgunAnim.play("fire")
	get_node("railgunSFX" + str(randi_range(1, 3))).play()
	await get_tree().create_timer(0.5).timeout
	emit_signal("railgunFired")
	
