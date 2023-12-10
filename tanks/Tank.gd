extends CharacterBody2D

signal shootSignal
signal health_changed # Keep or remove?
signal dead

@export var Bullet : PackedScene
@export var speed : int
@export var rotation_speed : float
@export var gun_cooldown : float
@export var machine_gun_cooldown : float
@export var health : int

@export var max_recoil : float = 10.0
var current_recoil = 0.0

var can_shoot = true
var alive = true

func _ready():
	$GunTimer.wait_time = gun_cooldown
	$MachineGunTimer.wait_time = machine_gun_cooldown
	
func control(delta):
	pass

func shoot(bullet, turret):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	
	if can_shoot:
		can_shoot = false	
		
		# Check what type of bullet was shot
		if bullet_scene_path.match("*MachineGunBullet*"): $MachineGunTimer.start()
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
	if (health <= 0):
		alive = false
		queue_free() # Destroy object
		emit_signal("dead") # No one catches this signal yet

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide()
	
	var recoil_increment = max_recoil * 0.05
	if not Input.is_action_pressed("left_click") or Input.is_action_pressed("right_click"):
		current_recoil = clamp(current_recoil - recoil_increment, 0.0, max_recoil)
	print(current_recoil)

func _on_GunTimer_timeout():
	can_shoot = true
	
func _on_MachineGunTimer_timeout():
	can_shoot = true
