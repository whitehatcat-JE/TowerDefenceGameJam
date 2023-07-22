extends Control

func _on_background_ready():
	$Background.get_texture().set_width(size.x)
	$Background.get_texture().set_height(size.y)



func _on_restart_button_pressed():
	#Load menu scene
	get_tree().change_scene_to_file("res://UI/MenuUI.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
