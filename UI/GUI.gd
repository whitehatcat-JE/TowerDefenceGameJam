extends Control

func show_game_ui():
	$MenuUI.hide()
	$GameUI.show()

func show_menu_ui():
	$GameUI.hide()
	$MenuUI.show()
	
