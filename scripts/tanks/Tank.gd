extends CharacterBody2D

signal shootSignal
signal health_changed
signal max_health_changed
signal experience_changed
signal leveled_up
signal fuel_changed
signal died

@onready var burn_timer = $BurnTimer

var death_signal_emitted = false

var audio_manager

@export var max_health : int
var health
@export var max_fuel : int
@export var fuel_usage : float
var fuel_depletion_rate : float = 0.03
var fuel_gain = 40
var fuel
var level = 11
var experience = 0
var experience_to_level = 2
var alive = true
var inventory : Dictionary = {}
var bullet_inventory = ["player_bullet"]
var abilities = []
var main_camera

# Movement
@export var max_speed = 60
#var acceleration = max_speed * 10
#var friction = acceleration / max_speed
var friction = 0
@export var rotation_speed : float
# Combat
@export var Bullet : PackedScene
@export var gun_cooldown : float
@export var machine_gun_cooldown : float
@export var max_recoil : float = 10.0
var current_recoil = 0.0
var can_shoot = true
var bullet_scale_multiplier = 1
var bullet_damage_multiplier = 1

var current_bullet



func _ready():
	audio_manager = get_parent().get_parent().get_node("AudioManager")
	main_camera = get_tree().current_scene.find_child("MainCamera")
	health = max_health
	emit_signal("health_changed", health)
	fuel = max_fuel
	emit_signal("fuel_changed", fuel * 100/max_fuel)
	emit_signal("experience_changed", experience * 100/experience_to_level, level)
	$GunTimer.wait_time = gun_cooldown
	$MachineGunTimer.wait_time = machine_gun_cooldown
	$FuelUsageTimer.wait_time = fuel_depletion_rate
	current_bullet = "player_bullet"
	
func control(_delta):
	pass

func shoot(bullet):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	
	if can_shoot:
		can_shoot = false
		
		# Push player in opposite direction (apply force) ?
		
		# Check what type of bullet was shot
		if bullet_scene_path.match("*machine_gun_bullet*"):
			# Play sound effect
			audio_manager.play_random_sound(audio_manager.shoot_sounds)
			$MachineGunTimer.start()
		else:
			# Play sound effect
			audio_manager.play_sound("ShootSfx")
			$GunTimer.start()
			main_camera.shake(1)
		var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		var recoil_degree_max = current_recoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		var actual_bullet_direction = dir.rotated(recoil_radians_actual)
		
		var recoil_increment = max_recoil * 0.1
		current_recoil = clamp(current_recoil + recoil_increment, 0.0, max_recoil)
		
		emit_signal("shootSignal", bullet, $Weapon/Muzzle.global_position, actual_bullet_direction)
		
		# Secret upgrade
		if abilities.has("secret_ability"):
			dir = Vector2(1, 0).rotated($Weapon2.global_rotation)
			recoil_degree_max = current_recoil * 0.5
			recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
			actual_bullet_direction = dir.rotated(recoil_radians_actual)
			emit_signal("shootSignal", bullet, $Weapon2/Muzzle.global_position, actual_bullet_direction)

func change_bullet(bullet_number):
	# Check if player has bullet
	if bullet_number > bullet_inventory.size():
		return
	var hud = get_parent().get_node("MainCamera/HUD")
	var bullet_choice = hud.get_node("BulletChoice" + str(bullet_number))
	# Make previous current bullet hoveranimation visible = false
	if current_bullet != null:
		for i in range(1, 4):
			if current_bullet in hud.get_node("BulletChoice" + str(i)).get_node("Icon").texture.get_path():
				hud.get_node("BulletChoice" + str(i)).get_node("HoverAnimation").visible = false
				break
	var bullet = bullet_inventory[bullet_number - 1]
	current_bullet = bullet
	
	## Change the bullet of the player
	# Normal bullet
	if bullet == "player_bullet":
		Bullet = load("res://scenes/bullets/player_bullet.tscn")
		gun_cooldown = 0.5
		$GunTimer.wait_time = 0.5
		bullet_choice.get_node("Icon").texture = preload("res://assets/sprites/player_bullet_icon.png")
		bullet_choice.get_node("Info").text = "[center]" + "1"
	
	# Ability bullet
	else:
		Bullet = load(load_ability(bullet).bullet_path)
		gun_cooldown = load_ability(bullet).new_gun_cooldown
		$GunTimer.wait_time = load_ability(bullet).new_gun_cooldown
		
	
	# Visual changing of HUD
	
	bullet_choice.get_node("HoverAnimation").visible = true

func update_bullet_choice(bullet):
	var hud = get_parent().get_node("MainCamera/HUD")
	for i in range(0, bullet_inventory.size()):
		var texture = hud.get_node("BulletChoice" + str(i + 1)).get_node("Icon").texture
		if texture != null and current_bullet in texture.get_path():
			hud.get_node("BulletChoice" + str(i + 1)).get_node("HoverAnimation").visible = false
		if bullet == bullet_inventory[i]:
			var bullet_choice = hud.get_node("BulletChoice" + str(i + 1))
			bullet_choice.get_node("Icon").texture = load_ability(bullet).image
			bullet_choice.get_node("Info").text = "[center]" + str(i + 1)
			bullet_choice.get_node("HoverAnimation").visible = true
			current_bullet = bullet
			break

var burn_count = 0
var burn_damage
func burn(damage):
	# Play burn particles
	$Burn.emitting = true
	# Apply damage
	burn_damage = damage
	take_damage(damage)
	burn_timer.start()

func take_damage(damage):
	# Play sound effect
	audio_manager.play_sound("HurtSfx")
	
	health -= damage
	emit_signal("health_changed", health)
	
	main_camera.shake(4)
	
	if (health <= 0 and !death_signal_emitted):
		alive = false
		die() # Destroy object
		emit_signal("died", "death")
		death_signal_emitted = true

func die():
	pass
	#queue_free() # Should maybe not queue free the player object?

func gain_fuel(fuel_gain):
	if fuel + fuel_gain > max_fuel:
		fuel = max_fuel
	else:
		fuel += fuel_gain
	audio_manager.play_random_sound(audio_manager.gain_fuel_sounds)
	emit_signal("fuel_changed", fuel * 100/max_fuel)


func gain_health(health_gain):
	if health + health_gain > max_health:
		health = max_health
	else:
		health += health_gain
	emit_signal("health_changed", health)

func increase_max_health(new_max_health):
	max_health = new_max_health
	emit_signal("max_health_changed", new_max_health)

func gain_experience(experience_gain):
	experience += experience_gain
	emit_signal("experience_changed", experience * 100/experience_to_level, level)
	if experience >= experience_to_level:
		level_up()

func level_up():
	level += 1
	experience_to_level += 2
	experience -= experience_to_level
	emit_signal("experience_changed", experience * 100/experience_to_level, level)
	emit_signal("leveled_up", level)

func add_to_inventory(item):
	if inventory.has(item): inventory[item] = inventory[item] + 1
	else: inventory[item] = 1

func remove_from_inventory(item):
	inventory[item] = inventory[item] - 1

func add_fuel_to_base():
	# TODO: Play add fuel sound if has fuel?
	if inventory.has(Fuel):
		while inventory[Fuel] != 0:
			remove_from_inventory(Fuel)
			gain_fuel(fuel_gain)

var loaded_abilities = {}

func load_ability(name):
	if loaded_abilities.has(name):
		var scene_instance = loaded_abilities[name]
		return scene_instance
	else:
		var scene = load("res://scenes/abilities/" + name + "/" + name + ".tscn")
		var scene_instance = scene.instantiate()
		add_child(scene_instance)
		loaded_abilities[name] = scene_instance
		return scene_instance

func _physics_process(delta):
	if not alive:
		return
	
	if fuel <= 0 and !death_signal_emitted:
		emit_signal("died", "fuel")
		death_signal_emitted = true
	
	if fuel > 0:
		control(delta)
		move_and_slide()
		# Start the fuel timer if it's not running
		if $FuelUsageTimer.is_stopped():
			$FuelUsageTimer.start()
	if velocity == Vector2.ZERO:
		# Stop the fuel timer if the player isn't moving
		$FuelUsageTimer.stop()
	
	var recoil_increment = max_recoil * 0.05
	if not Input.is_action_pressed("left_click") or Input.is_action_pressed("right_click"):
		current_recoil = clamp(current_recoil - recoil_increment, 0.0, max_recoil)

func _on_GunTimer_timeout():
	can_shoot = true
	
func _on_MachineGunTimer_timeout():
	can_shoot = true

func _on_fuel_usage_timer_timeout():
	fuel -= fuel_usage
	emit_signal("fuel_changed", fuel * 100/max_fuel)
