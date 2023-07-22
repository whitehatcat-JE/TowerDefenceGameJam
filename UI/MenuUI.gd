extends Control


func _on_start_button_pressed():
	#Load game scene
	get_tree().change_scene_to_file("res://main/enviroment_3d.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
