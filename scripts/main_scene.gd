extends Node2D

var audio_manager
var current_score = 0
var enemies_count = 0
var max_enemies = 15

@onready var player = $Player

func _init():
	randomize()

func _ready():
	audio_manager = get_parent().get_node("AudioManager")
	player.connect("leveled_up", _on_player_leveled_up)

func _on_Tank_shootSignal(bullet, _position, _direction):
	var b = bullet.instantiate()
	if b.name != "EnemyBullet":
		b.scale *= player.bullet_scale_multiplier
		b.damage *= player.bullet_damage_multiplier
	add_child(b)
	b.start(_position, _direction)
	b.connect("explode_particles", _on_explode_particles_signal) # Connect

func _on_explode_particles_signal(explosion_particles, _position):
	call_deferred("explode_particles", explosion_particles, _position)

func explode_particles(explosion_particles, _position):
	var p = explosion_particles.instantiate()
	add_child(p)
	p.global_position = _position

# TODO: Divide enemy tank and bomber logic
func _on_enemy_tank_died(type, score_value, experience_drop, fuel_drop, heart_drop, explosion_particles, _position):
	enemies_count -= 1
	# Increase score of game
	get_parent().increase_score(score_value)
	get_node("MainCamera/HUD/Score").text = "[center]Score: " + str(get_parent().score)
	
	# Death particles
	var p = explosion_particles.instantiate()
	add_child(p)
	p.global_position = _position
	
	## Loot
	# Spawn experience
	for i in range(0, randi_range(2, 3)):
		call_deferred("item_spawn", experience_drop, _position)
		if "EnemyTank" not in type.name:
			break
	
	# Spawn fuel
	if fuel_drop != null:
		call_deferred("item_spawn", fuel_drop, _position)
	
	# Spawn heart
	if heart_drop != null:
		call_deferred("item_spawn", heart_drop, _position)

func item_spawn(drop_type, _position):
	var random_angle
	var random_direction
	random_angle = randf_range(0, 360)
	random_direction = Vector2.RIGHT.rotated(deg_to_rad(random_angle))
	var item = drop_type.instantiate()
	add_child(item)
	item.spawn(_position, random_direction)

# Enemy types to spawn
var enemy_list = [
	preload("res://scenes/enemy/enemy_tank.tscn")
]

func _on_spawn_timer_timeout():
	if enemies_count >= max_enemies:
		return
	spawn_random_enemy()

func spawn_random_enemy():
	enemies_count += 1
	# Get random spawn location
	var nodes = get_parent().get_tree().get_nodes_in_group("spawner")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	$Spawner.position = position
	# Get random enemy
	var enemy_to_spawn = enemy_list.pick_random()
	var enemy_instance = enemy_to_spawn.instantiate()
	enemy_instance.position = $Spawner.position
	add_child(enemy_instance)
	# Connect signals
	enemy_instance.connect("shootSignal", _on_Tank_shootSignal)
	enemy_instance.connect("died", _on_enemy_tank_died)

func _on_player_leveled_up(level):
	# Change difficulty of game
	if level == 3:
		enemy_list.append(preload("res://scenes/enemy/enemy_bomber.tscn"))
	if $SpawnTimer.wait_time > 0.5:
		$SpawnTimer.wait_time -= 0.3
