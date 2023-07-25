extends Node2D

signal levelledUp

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
var upgradeQueue:Array[UPGRADES] = [UPGRADES.emp, UPGRADES.turrets, UPGRADES.wall, UPGRADES.secondaryTurrets, UPGRADES.railgun]

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
			GV.startingHealth += 5
		UPGRADES.emp:
			$empUpgradeSFX.play()
			$empAnim.play("emp")
		UPGRADES.turrets:
			$minigunUpgradeSFX.play()
			secondBulletUnlocked = true
		UPGRADES.secondaryTurrets:
			$minigunUpgradeSFX.play()
			get_parent().get_node("enemyTimer").wait_time *= 0.5
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
	get_node("shotSFX" + str(randi_range(1, 5))).play()
	
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
