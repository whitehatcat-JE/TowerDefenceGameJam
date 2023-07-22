extends Control

func _ready():
	show_menu_ui()
	$MenuUI/StartButton.pressed.connect(show_game_ui)
	$GameUI/RageQuitButton.pressed.connect(show_end_ui)
	$EndUI/RestartButton.pressed.connect(show_menu_ui)


func show_game_ui():
	$MenuUI.hide()
	$EndUI.hide()
	$GameUI.show()

func show_menu_ui():
	$GameUI.hide()
	$EndUI.hide()
	$MenuUI.show()

func show_end_ui():
	$GameUI.hide()
	$MenuUI.hide()
	$EndUI.show()
