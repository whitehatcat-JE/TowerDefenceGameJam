extends Control


func _on_background_ready():
	$Background.get_texture().set_width(size.x)
	$Background.get_texture().set_height(size.y)
