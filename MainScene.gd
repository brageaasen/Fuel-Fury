extends Node2D

func _on_Tank_shootSignal(bullet, _position, _direction):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction)	



func _on_base_ammo_updated():
	$HUD.update_ammo($Player.ammo_storage)

