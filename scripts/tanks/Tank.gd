extends CharacterBody2D

signal shootSignal
signal health_changed
signal experience_changed
signal fuel_changed
signal died

@export var max_health : int
var health
@export var max_fuel : int
@export var fuel_usage : float
var fuel_depletion_rate : float = 0.03
var fuel_gain = 40
var fuel
var level = 1
var experience = 0
var experience_to_level = 5
var alive = true
var inventory : Dictionary = {}
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



func _ready():
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	fuel = max_fuel
	emit_signal("fuel_changed", fuel * 100/max_fuel)
	emit_signal("experience_changed", experience * 100/experience_to_level, level)
	$GunTimer.wait_time = gun_cooldown
	$MachineGunTimer.wait_time = machine_gun_cooldown
	$FuelUsageTimer.wait_time = fuel_depletion_rate
	
func control(_delta):
	pass

func shoot(bullet):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	
	if can_shoot:
		can_shoot = false
		
		# Check what type of bullet was shot
		if bullet_scene_path.match("*machine_gun_bullet*"): $MachineGunTimer.start()
		else: $GunTimer.start()
		var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		var recoil_degree_max = current_recoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		var actual_bullet_direction = dir.rotated(recoil_radians_actual)	
		
		
		# TODO: Add recoil
		var recoil_increment = max_recoil * 0.1
		current_recoil = clamp(current_recoil + recoil_increment, 0.0, max_recoil)
		
		
		emit_signal("shootSignal", bullet, $Weapon/Muzzle.global_position, actual_bullet_direction)

func take_damage(damage):
	health -= damage
	emit_signal("health_changed", health * 100/max_health)
	if (health <= 0):
		alive = false
		die() # Destroy object
		emit_signal("died") # No one catches this signal yet

func die():
	queue_free() # Should maybe not queue free the player object?

func gain_fuel(fuel_gain):
	print("Gained fuel:")
	if fuel + fuel_gain > max_fuel:
		fuel = max_fuel
	else:
		fuel += fuel_gain
	emit_signal("fuel_changed", fuel * 100/max_fuel)

func gain_experience(experience_gain):
	print("Gained experience:")
	experience += experience_gain
	print(experience)
	emit_signal("experience_changed", experience * 100/experience_to_level, level)
	if experience >= experience_to_level:
		level_up()

func level_up():
	print("Leveled up!")
	level += 1
	experience -= experience_to_level
	print(experience)
	emit_signal("experience_changed", experience * 100/experience_to_level, level)
	# Upgrades?

func add_to_inventory(item):
	if inventory.has(item): inventory[item] = inventory[item] + 1
	else: inventory[item] = 1

func remove_from_inventory(item):
	inventory[item] = inventory[item] - 1

func add_fuel_to_base():
	# Play add fuel sound if has fuel?
	if inventory.has(Fuel):
		while inventory[Fuel] != 0:
			remove_from_inventory(Fuel)
			gain_fuel(fuel_gain)

func _physics_process(delta):
	if not alive:
		return
	
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
