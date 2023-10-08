extends Node2D

#const PARTICLES_PATH = "res://particles/"

func _on_Tank_shootSignal(bullet, _position, _direction):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction)	
	b.start(_position, _direction)
	b.connect("explode_particles", _on_explode_particles_signal) # Connect


func _on_explode_particles_signal(Explosion_particles, _position):
	#var name = particles.get_filename()
	var p = preload("res://particles/Explosion.tscn").instantiate()
	add_child(p)
	p.global_position = _position
