extends "res://scripts/ai/enemy.gd"

@export var Bullet : PackedScene
@export var fuel_drop : PackedScene
@export var rotation_speed : float
@export var gun_cooldown : float
@export var machine_gun_cooldown : float
@export var turret_speed : float

@onready var burn_timer = $BurnTimer
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_player = $PlayerDetection
@onready var fsm = $FiniteStateMachine as FiniteStateMachine
@onready var enemy_tank_wander_state = $FiniteStateMachine/EnemyTankWanderState as EnemyTankWanderState
@onready var enemy_tank_chase_state = $FiniteStateMachine/EnemyTankChaseState as EnemyTankChaseState
@onready var enemy_tank_attack_state = $FiniteStateMachine/EnemyTankAttackState as EnemyTankAttackState

var player # Reference to the player node or position
var target_dir

func _ready():
	super._ready() # Make parent also run its ready function
	player = get_node("/root/Game/MainScene/Player")
	$GunTimer.wait_time = gun_cooldown
	$MachineGunTimer.wait_time = machine_gun_cooldown
	burn_timer.wait_time = 2
	ray_cast_player.target_position.x = detect_radius
	
	# On found_player, wander -> chase
	enemy_tank_wander_state.found_player.connect(fsm.change_state.bind(enemy_tank_chase_state))
	# On lost_player, chase -> wander
	enemy_tank_chase_state.lost_player.connect(fsm.change_state.bind(enemy_tank_wander_state))
	# On attack_player, chase -> wander
	enemy_tank_chase_state.attack_player.connect(fsm.change_state.bind(enemy_tank_attack_state))
	# On out_of_range, attack -> chase
	enemy_tank_attack_state.out_of_range.connect(fsm.change_state.bind(enemy_tank_chase_state))


func die():
	alive = false
	queue_free()
	emit_signal("died", self, score_value, experience_drop, fuel_drop, null, preload("res://scenes/particles/death_explosion.tscn"), global_position)


func shoot(bullet):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	
	# Check if allowed to shoot
	if can_shoot:
		can_shoot = false
		
		# Check what type of bullet was shot
		if bullet_scene_path.match("*machine_gun_bullet*"): $MachineGunTimer.start()
		else:
			$GunTimer.start()
		
		# Calculate direction and recoil
		var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		var recoil_degree_max = current_recoil * 0.5
		var recoil_radians_actual = deg_to_rad(randf_range(-recoil_degree_max, recoil_degree_max))
		var actual_bullet_direction = dir.rotated(recoil_radians_actual)	
		var recoil_increment = max_recoil * 0.1
		current_recoil = clamp(current_recoil + recoil_increment, 0.0, max_recoil)
		
		emit_signal("shootSignal", bullet, $Weapon/Muzzle.global_position, actual_bullet_direction)

func take_damage(damage):
	animation_player.play("take_damage")
	health -= damage
	emit_signal("health_changed", health * 100/max_health)
	if (health <= 0):
		die() # Destroy object

var burn_count = 0
var burn_damage
func burn(damage):
	# Play burn particles
	$Burn.emitting = true
	# Apply damage
	burn_damage = damage
	take_damage(damage)
	burn_timer.start()

func _physics_process(delta):
	if not alive:
		return
	
	if target:
		target_dir = (target.global_position - global_position).normalized()
	var recoil_increment = max_recoil * 0.05
	# TODO: Make recoil for enemy aswell
	if not Input.is_action_pressed("left_click") or Input.is_action_pressed("right_click"):
		current_recoil = clamp(current_recoil - recoil_increment, 0.0, max_recoil)

func _on_GunTimer_timeout():
	can_shoot = true
	
func _on_MachineGunTimer_timeout():
	can_shoot = true

func _on_burn_timer_timeout():
	burn_count += 1
	if burn_count < 4:
		burn(burn_damage)
	else:
		burn_count = 0

func _on_detect_radius_body_entered(body):
	if body.name == "Player":
		target = body

func _on_detect_radius_body_exited(body):
	if body == target:
		target = null


