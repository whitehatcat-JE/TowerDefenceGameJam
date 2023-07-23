extends Node2D

enum UPGRADES {
	crossbow,
	cannon
}

@onready var towerPos = $towerCollisions.global_position
@onready var spawnBullet = preload("res://main/objects/projectile_generic.tscn")



var xp_threshold:float = 5.0

var unlockedUpgrades:Array[UPGRADES] = []
var upgradeQueue:Array[UPGRADES] = [UPGRADES.crossbow, UPGRADES.cannon]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GV.xp > GV.xpThreshold:
		GV.xp -= GV.xpThreshold
		levelUp()

func levelUp():
	if len(upgradeQueue) > 0:
		upgradeTower(upgradeQueue.pop_front())

func upgradeTower(newUpgrade:UPGRADES):
	unlockedUpgrades.append(newUpgrade)
	match newUpgrade:
		UPGRADES.crossbow:
			pass
		UPGRADES.cannon:
			pass

func attackEnemy():
	var closestEnemyLocation = Vector2(200000, 200000)
	
	for enemy in range(len(GV.enemies)):
		if GV.enemies[enemy].global_position.distance_to(towerPos) < closestEnemyLocation.distance_to(towerPos):
			closestEnemyLocation = GV.enemies[enemy].global_position
			#print("Enemy ", enemy, " chosen")
	
	var bullet:Node = spawnBullet.instantiate()
	self.add_child(bullet)
	bullet.global_position = towerPos
	bullet.target = closestEnemyLocation
	#print("Bullet fired")

func towerHealing():
	
	if GV.curPlayerLoc.distance_to(towerPos) < 100:
		print("Player is in range")
		if GV.get_health() != GV.startingHealth:
			GV.change_health(1)
			print("Player healed tower")
