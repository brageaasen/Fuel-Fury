extends Node2D

#const PARTICLES_PATH = "res://particles/"
var audio_manager
var current_score = 0

@onready var player = $Player

func _init():
	randomize()
func _ready():
	audio_manager = get_parent().get_node("AudioManager")

func _on_Tank_shootSignal(bullet, _position, _direction):
	var b = bullet.instantiate()
	b.scale *= player.bullet_scale_multiplier
	b.damage *= player.bullet_damage_multiplier
	add_child(b)
	b.start(_position, _direction)
	b.connect("explode_particles", _on_explode_particles_signal) # Connect

func _on_explode_particles_signal(explosion_particles, _position):
	# Play sound effect
	audio_manager.play_sound("ExplosionSfx")
	
	var p = explosion_particles.instantiate()
	add_child(p)
	p.global_position = _position


func _on_enemy_tank_died(score_value, experience_drop, fuel_drop, explosion_particles, _position):
	# Increase score of game
	get_parent().increase_score(score_value)
	get_node("MainCamera/HUD/Score").text = "[center]Score: " + str(get_parent().score)
	
	# Death particles
	var p = explosion_particles.instantiate()
	add_child(p)
	p.global_position = _position
	
	## Loot
	var e = experience_drop.instantiate()
	# Spawn experience
	add_child(e)
	var randomAngle = randf_range(0, 360)
	var randomDirection = Vector2.RIGHT.rotated(deg_to_rad(randomAngle))
	e.spawn(_position, randomDirection)
	
	# Spawn fuel
	var f
	if fuel_drop != null:
		f = fuel_drop.instantiate()
		add_child(f)
		randomAngle = randf_range(0, 360)
		randomDirection = Vector2.RIGHT.rotated(deg_to_rad(randomAngle))
		f.spawn(_position, randomDirection)

# Enemy types to spawn
var enemy_list = [
	preload("res://scenes/enemy/enemy_tank.tscn"),
	preload("res://scenes/enemy/enemy_bomber.tscn")
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
	# Connect signals
	enemy_instance.connect("shootSignal", _on_Tank_shootSignal)
	enemy_instance.connect("died", _on_enemy_tank_died)

