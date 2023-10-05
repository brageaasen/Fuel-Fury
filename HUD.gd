extends Control


func _on_player_ammo_updated(ammo_count):
	$AmmoStorage.text = "Ammo: " + str(ammo_count)
