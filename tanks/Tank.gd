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

var can_shoot = true
var alive = true

func _ready():
	$GunTimer.wait_time = gun_cooldown
	$MachineGunTimer.wait_time = machine_gun_cooldown
	
func control(delta):
	pass

func shoot(bullet_type, turret):
	if can_shoot:
		can_shoot = false
		if (turret == "MG"): $MachineGunTimer.start()
		else: $GunTimer.start()
		var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		emit_signal("shootSignal", bullet_type, $Weapon/Muzzle.global_position, dir)

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

func _on_GunTimer_timeout():
	can_shoot = true
	
func _on_MachineGunTimer_timeout():
	can_shoot = true
