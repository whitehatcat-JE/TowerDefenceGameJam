extends Control

func update_health_bar(currentHealth:float, maxHealth:float):
	$HealthBar.set_max(maxHealth)
	$HealthBar.set_value(currentHealth)
	$HealthBar/Label.set_text(String.num(currentHealth,0)+"/"+String.num(maxHealth,0))

func update_xp_bar(currentXP:float, maxXP:float):
	$XPBar.set_max(maxXP)
	$XPBar.set_value(currentXP)
	$XPBar/Label.set_text(String.num(currentXP,0)+"/"+String.num(maxXP,0))
	
func debug_rand_change():
	var mH = randf_range(1,500)
	var cH = randf_range(0,mH)
	var mX = randf_range(1,500)
	var cX = randf_range(0,mX)
	update_health_bar(cH,mH)
	update_xp_bar(cX,mX)
	

func _on_rage_quit_button_pressed():
	#Load End Screen
	get_tree().change_scene_to_file("res://UI/EndUI.tscn")
