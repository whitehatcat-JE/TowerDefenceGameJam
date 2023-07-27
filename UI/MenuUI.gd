extends Control

var runningFade:bool = false

func _ready():
	# One-time Score setup
	$HighscoreLabel.set_text("Highscore: " + String.num(Stats.get_highscore() * 100))
	# Connect signals
	$StartButton.pressed.connect(_on_start_button_pressed)
	$QuitButton.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed():
	if runningFade: return;
	runningFade = true
	$fadeAnim.play("fadeOut")

func _on_quit_button_pressed():
	if runningFade: return;
	get_tree().quit()

func startGame():
	get_tree().change_scene_to_file("res://main/enviroment_3d.tscn")

func _on_entry_anim_animation_finished(anim_name):
	if anim_name == "enter":
		$entryAnim.play("float")


func hover():
	$menuHover.play()


func click():
	$menuClick.play()
