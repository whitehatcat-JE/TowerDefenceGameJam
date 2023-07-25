extends Area2D

signal hitEnemy

var damageMin:int = 1
var damageMax:int = 3

func _on_body_entered(body):
	if body.has_method("damage"):
		emit_signal("hitEnemy")
		var damageAmt:int = randi_range(damageMin, damageMax)
		body.playerDamaged = true
		body.damage(1 if damageAmt <= 2 else 3)
