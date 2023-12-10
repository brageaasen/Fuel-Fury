extends Control


func _on_player_ammo_updated(bullet, ammo_count):
	var bullet_scene_path = bullet.get_path().get_file()
	if bullet_scene_path.match("*PlayerBullet*"):
		$AmmoStorage.text = "Ammo: " + str(ammo_count)
	elif bullet_scene_path.match("*MachineGunBullet*"):
		$MachineGunAmmoStorage.text = "Ammo: " + str(ammo_count)
