extends Node2D


var enemyValues = [ # Temp values
	["rookie", 1],
	["leader", 2],
	["mafiaBoss", 3]
]



@onready var enemies:Dictionary = {
	"rookie":preload("res://main/objects/enemy.tscn"),
	"leader":preload("res://main/objects/bug.tscn"),
	"mafiaBoss":preload("res://main/objects/tank.tscn")
}
@onready var xp = preload("res://main/objects/xp.tscn")

var waveBudget:int = 50
var spawnDelay:float = 1.0

@onready var playerLoc:Vector2 = $Player.position

@onready var nwConst = %worldConstraintNW
@onready var seConst = %worldConstraintSE

@onready var nwVision = %visionNW
@onready var seVision = %visionSE

@onready var waveTimer = %waveTimer
@onready var cam = %camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	playerLoc = $Player.position
	while len(GV.xpQueue) > 0:
		spawnXp(GV.xpQueue.pop_front())

func spawnHandler(enemyType):
	for recursionDepth in range(250): # Prevents recursion issues
		var spawnLoc:Vector2 = Vector2(randf_range(nwConst.position.x, seConst.position.x),
		 randf_range(nwConst.position.y, seConst.position.y))
		if spawnLoc.x > nwVision.global_position.x and spawnLoc.x < seVision.global_position.x:
			continue
		if spawnLoc.y > nwVision.global_position.y and spawnLoc.y < seVision.global_position.y:
			continue
		var newEnemy:Node = enemies[enemyType].instantiate()
		self.add_child(newEnemy)
		newEnemy.position = spawnLoc
		newEnemy.target = $tower.position
		GV.enemies.append(newEnemy)
		return

func _on_wave_timer_timeout():
	var budget:int = waveBudget
	while budget > 0:
		var typeRequested:int = randi_range(0, len(enemyValues) - 1)
		while enemyValues[typeRequested][1] > budget:
			typeRequested -= 1
		budget -= enemyValues[typeRequested][1]
		spawnHandler(enemyValues[typeRequested][0])
		await get_tree().create_timer(spawnDelay).timeout
	waveTimer.start()

func spawnXp(enemyPos):
	var newXp = xp.instantiate()
	self.add_child(newXp)
	newXp.global_position = enemyPos + Vector2(randf_range(-10, 10), randf_range(-10, 10))
