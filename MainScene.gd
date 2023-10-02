extends Node2D

func _on_Tank_shootSignal(bullet, _position, _direction):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction)	
