extends Node2D

#const PARTICLES_PATH = "res://particles/"

func _init():
	randomize()

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


func _on_enemy_tank_died(experience_drop, fuel_drop, _position):
	var e = experience_drop.instantiate()
	var f = fuel_drop.instantiate()
	# Spawn experience
	add_child(e)
	var randomAngle = randf_range(0, 360)
	var randomDirection = Vector2.RIGHT.rotated(deg_to_rad(randomAngle))
	e.spawn(_position, randomDirection)
	
	# Spawn fuel
	add_child(f)
	randomAngle = randf_range(0, 360)
	randomDirection = Vector2.RIGHT.rotated(deg_to_rad(randomAngle))
	f.spawn(_position, randomDirection)

var enemy_list = [
	preload("res://scenes/enemy/enemy_tank.tscn")
]

func _on_spawn_timer_timeout():
	var nodes = get_parent().get_tree().get_nodes_in_group("spawner")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	$Spawner.position = position

	var enemy_to_spawn = enemy_list.pick_random()
	var enemy_instance = enemy_to_spawn.instantiate()
	enemy_instance.position = $Spawner.position
	add_child(enemy_instance)
	print(enemy_instance)
	# Connect signals
	#emitter_node.connect("signal_name", self, "method_on_self")
	enemy_instance.connect("shootSignal", _on_Tank_shootSignal)
	enemy_instance.connect("died", _on_enemy_tank_died)
