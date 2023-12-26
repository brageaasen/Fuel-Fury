extends "res://scripts/tanks/tank.gd"

@export var ammo_storage : int = 30
var heavy_bullet : PackedScene = load( "res://scenes/bullets/player_bullet.tscn" )

@onready var tank_trail = $TankTrail/Particles
@onready var tank_trail_2 = $TankTrail2/Particles


# Abilities
var abilities = []

@onready var animation_player = $AnimationPlayer
signal ammo_updated # Signal for HUD


var target_velocity

func _ready():
	super._ready() # Make parent also run its ready function
	ammo_updated.emit(heavy_bullet, ammo_storage)

# Move and attack with player
func control(delta):
	$Weapon.look_at(get_global_mouse_position())
	move_and_rotate(delta)
	apply_friction(delta)
	
	# Attack input
	if Input.is_action_pressed("left_click"):
		if ammo_storage > 0:
			shoot(Bullet)
	if abilities.has("machine_gun"):
		load_ability("machine_gun").execute(self)

func move_and_rotate(delta):
	# Rotate the player
	var rotation_direction = 0
	if Input.is_action_pressed("turn_right"):
		rotation_direction += 1
		animation_player.play("move")
	if Input.is_action_pressed("turn_left"):
		rotation_direction -= 1
		animation_player.play("move")
	rotation += rotation_speed * rotation_direction * delta
	
	# Move the player
	velocity = Vector2()
	if Input.is_action_pressed("forward"):
		velocity = Vector2(max_speed, 0).rotated(rotation)
		animation_player.play("move")
		tank_trail.emitting = true
		tank_trail_2.emitting = true
	if Input.is_action_pressed("back"):
		velocity = Vector2(-max_speed/2, 0).rotated(rotation)
		animation_player.play("move")
	if velocity == Vector2.ZERO:
		tank_trail.emitting = false
		tank_trail_2.emitting = false

# Remove?
func apply_friction(delta):
	velocity -= velocity * friction * delta

func _on_base_ammo_updated(type):
	if type == "mg" and abilities.has("machine_gun"):
		load_ability("machine_gun").mg_ammo_storage += 1
		load_ability("machine_gun").emit_ammo_update()
	else:
		ammo_updated.emit(heavy_bullet, ammo_storage)
		ammo_storage += 1


func _on_shoot_signal(bullet, _position, _direction):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	# Check what type of bullet was shot
	if bullet_scene_path.match("*player_bullet*"):
		ammo_storage -= 1
		ammo_updated.emit(bullet, ammo_storage)
	elif bullet_scene_path.match("*machine_gun_bullet*") and abilities.has("machine_gun"):
		load_ability("machine_gun").mg_ammo_storage -= 1
		load_ability("machine_gun").emit_ammo_update()
