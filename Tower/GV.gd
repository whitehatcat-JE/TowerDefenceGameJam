extends Node

var enemies:Array = []

var startingHealth:int = 100
var _health:int = startingHealth

var xp:int = 0
var xpThreshold:int = 50
var xpQueue:Array = []

var curPlayerLoc:Vector2 = Vector2()

func get_health():
	return _health

func change_health(change):
	_health += change
	if(_health > startingHealth):
		_health = startingHealth

func reset():
	_health = startingHealth
	xp = 0
	xpThreshold = 100
	xpQueue = []
	curPlayerLoc = Vector2()
	enemies = []
