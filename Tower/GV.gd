extends Node

var enemies:Array = []
var justDamaged = false
var startingHealth:int = 5
var _health:int = startingHealth

var xp:int = 0
var xpThreshold:int = 20
var xpQueue:Array = []
var healQueue:Array = []

var curPlayerLoc:Vector2 = Vector2()

func get_health():
	return _health

func change_health(change):
	_health += change
	justDamaged = true
	if(_health > startingHealth):
		_health = startingHealth

func reset():
	_health = 5
	startingHealth = 5
	xp = 0
	xpThreshold = 20
	xpQueue = []
	curPlayerLoc = Vector2()
	enemies = []
