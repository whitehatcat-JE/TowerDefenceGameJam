extends Control

func _ready():
	$HighscoreLabel.set_text("Highscore: " + String.num(Stats.get_highscore()))

func _on_start_button_pressed():
	#Load game scene
	Stats.reset_score()
	get_tree().change_scene_to_file("res://main/enviroment_3d.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
	
