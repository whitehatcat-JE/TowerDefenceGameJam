extends Node3D

const SCALE_DIF:float = 96.0

var defPlayerLoc:Vector2 = Vector2()
@onready var defCameraLoc:Vector3 = $Camera3D.position
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	defPlayerLoc = %level.playerLoc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var plrDif:Vector2 = (%level.playerLoc - defPlayerLoc) / SCALE_DIF
	$Camera3D.position.x = plrDif.x + defCameraLoc.x
	$Camera3D.position.z = plrDif.y + defCameraLoc.z
	var healDif:Vector2 = ($levelViewport/level/healLocation.position) / SCALE_DIF
	$healLight.position.x = healDif.x - 5.2
	$healLight.position.z = healDif.y - 3.2
	var railDir:Vector2 = ($levelViewport/level/tower/railgunAttack/targetDirection.global_position) / SCALE_DIF
	$tower/towerRailgun/railgunPivot.look_at(Vector3(railDir.x - 5.2, 9.0, railDir.y - 3.2))
	if GV.get_health() <= 0 and !dead:
		dead = true
		$towerDestructionAnim.play("destroy")
		get_tree().paused = true

func _on_player_plr_attack():
	$Camera3D/screenshake.play("shake")

func _on_tower_destruction_anim_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://UI/MenuUI.tscn")

func _on_tower_walls_unlocked():
	$tower/walls.visible = true

func _on_tower_railgun_fired():
	$tower/towerRailgun/railgunPivot/railgunParticles.emitting = true

func _on_tower_emp_unlocked():
	$tower/empField.visible = true

func _on_tower_railgun_unlocked():
	$tower/towerTurrets4.visible = false
	$tower/towerRailgun.visible = true

func _on_tower_secondary_turrets_unlocked():
	$tower/towerTurrets2.visible = false
	$tower/towerTurrets4.visible = true

func _on_tower_turrets_unlocked():
	$tower/towerNoTurrets.visible = false
	$tower/towerTurrets2.visible = true
