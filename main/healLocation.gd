extends Node2D

signal healed

var timeLeft:int = 3

func healPlayer():
	if GV._health < GV.startingHealth:
		GV._health += 1
	emit_signal("healed")

func _on_heal_timer_timeout():
	timeLeft -= 1
	$sprite/healTimerDisplay.text = str(timeLeft)
	if timeLeft == 0:
		$sprite.modulate = "ffffff00"
		healPlayer()
	else:
		$healTimer.start()

func _on_player_scanner_body_entered(body):
	$healTimer.start()
	$healSFX.play()
	modulate = "ffffff"
	$sprite/healTimerDisplay.text = "3"

func _on_player_scanner_body_exited(body):
	modulate = "ffffff93";
	$healTimer.stop()
	$sprite/healTimerDisplay.text = "-"
	if timeLeft != 0:
		$healSFX.stop()
	timeLeft = 3
