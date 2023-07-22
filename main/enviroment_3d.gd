extends Node3D

const SCALE_DIF:float = 96.0

var defPlayerLoc:Vector2 = Vector2()
@onready var defCameraLoc:Vector3 = $Camera3D.position

# Called when the node enters the scene tree for the first time.
func _ready():
	defPlayerLoc = %level.playerLoc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var plrDif:Vector2 = (%level.playerLoc - defPlayerLoc) / SCALE_DIF
	$Camera3D.position.x = plrDif.x + defCameraLoc.x
	$Camera3D.position.z = plrDif.y + defCameraLoc.z

func _on_player_plr_attack():
	$Camera3D/screenshake.play("shake")
