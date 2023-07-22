extends Node2D

enum UPGRADES {
	crossbow,
	cannon
}

var xp_threshold:float = 5.0
var xp:float = 0.0

var unlockedUpgrades:Array[UPGRADES] = []
var upgradeQueue:Array[UPGRADES] = [UPGRADES.crossbow, UPGRADES.cannon]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	xp += delta
	if xp > xp_threshold:
		xp -= xp_threshold
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
