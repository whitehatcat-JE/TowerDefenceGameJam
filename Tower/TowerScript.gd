extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_text_newline"):
		if $TestCube.visible == true:
			$TestCube.visible = false
			$TestCube2.visible = true
		
		elif $TestCube2.visible == true:
			$TestCube2.visible = false
			$TestCube3.visible = true
		
		elif $TestCube3.visible == true:
			$TestCube3.visible = false
			$TestCube.visible = true
