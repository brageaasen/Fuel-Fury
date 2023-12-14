extends Node2D

#const PARTICLES_PATH = "res://particles/"

func _on_Tank_shootSignal(bullet, _position, _direction):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction)
	b.connect("explode_particles", _on_explode_particles_signal) # Connect

func _on_explode_particles_signal(explosion_particles, _position):
	# TODO: Make us of generic ( explosion_particles ) instead of just using
	#		singular explosion particles.
	#var name = particles.get_filename()
	var p = preload("res://scenes/particles/explosion.tscn").instantiate()
	add_child(p)
	p.global_position = _position


func _on_enemy_tank_died(experience_drop, _position):
	var e = experience_drop.instantiate()
	add_child(e)
	e.global_position = _position
	e.on_spawn()
