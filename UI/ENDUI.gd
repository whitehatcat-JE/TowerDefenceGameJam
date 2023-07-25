extends Control

func _ready():
	if !get_tree().paused: _on_restart_button_button_down();
	set_score_label()
	Stats.reset_score()
	GV.reset()
	$fadeInAnim.play("fadeIn")

func set_score_label():
	var scoretext= "Score: " + String.num(Stats.get_score() * 100) + "\n" 
	scoretext += "High Score: " + String.num(Stats.get_highscore() * 100)
	$ScoreLabel.set_text(scoretext)

func _on_rage_quit_button_button_down():
	get_tree().quit()

func _on_restart_button_button_down():
	visible = false
	position.y = 10000
	get_tree().paused = false
