extends Area2D

var damageAmt:float = 1.0

func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(damageAmt)
