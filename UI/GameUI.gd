extends Control

#fade length, in seconds
var fade_length:float = 1
var fade_time:float = 0
var game_over = false

func _ready():
	$FadeRect.modulate.a = 0;
	# Score setup
	on_score_updated()
	# Connect signals
	Stats.score_changed.connect(on_score_updated)
	$RageQuitButton.pressed.connect(_on_rage_quit_button_pressed)

func _process(delta):
	update_xp_bar(GV.xp, GV.xpThreshold)
	update_health_bar(GV.get_health(), GV.startingHealth)
	
	if GV.justDamaged:
		$damageAnim.play("damage")
		GV.justDamaged = false

func update_health_bar(currentHealth:float, maxHealth:float):
	if currentHealth < 0: currentHealth = 0
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

func on_score_updated():
	var scoretext= "Score: " + String.num(Stats.get_score() * 100) + "\n" 
	scoretext += "High Score: " + String.num(Stats.get_highscore() * 100)
	$ScoreLabel.set_text(scoretext)

func _on_rage_quit_button_pressed():
	#Load End Screen
	game_over = true

