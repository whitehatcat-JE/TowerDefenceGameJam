extends Control

func _ready():
	set_score_label()

func _on_background_ready():
	$Background.get_texture().set_width(size.x)
	$Background.get_texture().set_height(size.y)

func _on_restart_button_pressed():
	#Load menu scene
	get_tree().change_scene_to_file("res://UI/MenuUI.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func set_score_label():
	var scoretext= "Score: " + String.num(Stats.get_score()) + "\n" 
	scoretext += "High Score: " + String.num(Stats.get_highscore())
	$ScoreLabel.set_text(scoretext)
