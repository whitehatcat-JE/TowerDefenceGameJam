extends Area2D

func _ready():
	if randf() > 0.666:
		$sprite1.visible = true
	elif randf() > 0.5:
		$sprite2.visible = true
	else:
		$sprite3.visible = true

func _on_timer_timeout():
	queue_free()
