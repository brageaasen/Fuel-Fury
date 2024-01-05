extends Control

@onready var player = $"../../Player"

func _ready():
	# Delay signal connections for 0.1 seconds to ensure nodes are initialized
	await get_tree().create_timer(0.1).timeout
	connect_signals()

func connect_signals():
	player.connect("health_changed", update_healthbar)
	player.connect("max_health_changed", update_healthbar_max_value)
	player.connect("experience_changed", update_experiencebar)


func update_healthbar(value):
	var tween = create_tween()
	tween.tween_property($HealthBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)
	$Health.text = "HP:" + str(value)
	
func update_healthbar_max_value(value):
	$HealthBar.max_value = value

func update_experiencebar(value, level):
	var tween = create_tween()
	tween.tween_property($ExperienceBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)
	$Level.text = "LvL:" + str(level)

func _on_player_ammo_updated(bullet, ammo_count):
	var bullet_scene_path = bullet.get_path().get_file()
	if bullet_scene_path.match("*player_bullet*") or bullet_scene_path.match("*fire_bullet*") or bullet_scene_path.match("*explosive_bullet*"):
		$AmmoStorage.text = str(ammo_count) + ","
	elif bullet_scene_path.match("*machine_gun_bullet*"):
		$MachineGunAmmoStorage.text = "MG:" + str(ammo_count)
