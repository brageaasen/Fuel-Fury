extends "res://scripts/tanks/tank.gd"

@export var ammo_storage : int = 30
var heavy_bullet : PackedScene = load( "res://scenes/bullets/player_bullet.tscn" )
var machine_gun_bullet : PackedScene = preload("res://scenes/bullets/machine_gun_bullet.tscn")

@onready var tank_trail = $TankTrail/Particles
@onready var tank_trail_2 = $TankTrail2/Particles
@onready var gun_timer = $GunTimer

@onready var animation_player = $AnimationPlayer
signal ammo_updated # Signal for HUD


var target_velocity
var sound_playing = false  # Flag to check if sound is playing

func _ready():
	super._ready() # Make parent also run its ready function
	ammo_updated.emit(heavy_bullet, ammo_storage)

# Move and attack with player
func control(delta):
	$Weapon.look_at(get_global_mouse_position())
	if abilities.has("secret_ability"):
		$Weapon2.look_at(get_global_mouse_position())
		$Weapon2.rotate(deg_to_rad(180))
		
	move_and_rotate(delta)
	apply_friction(delta)
	
	# Attack input
	if Input.is_action_pressed("left_click"):
		if ammo_storage > 0:
			shoot(Bullet)
		else:
			if not sound_playing:  # Check if the sound is not already playing
				sound_playing = true  # Set the flag to indicate sound is playing
				audio_manager.play_random_sound(audio_manager.empty_mag_sounds)
				await get_tree().create_timer(0.4).timeout  # Wait for 0.4 seconds
				sound_playing = false  # Reset the flag after waiting
	if abilities.has("machine_gun"):
		load_ability("machine_gun").execute(self)
		if load_ability("machine_gun").mg_ammo_storage <= 0 and Input.is_action_pressed("right_click"):
			if not sound_playing:  # Check if the sound is not already playing
				sound_playing = true  # Set the flag to indicate sound is playing
				audio_manager.play_random_sound(audio_manager.empty_mag_sounds)
				await get_tree().create_timer(0.1).timeout  # Wait for 0.1 seconds
				sound_playing = false  # Reset the flag after waiting

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
	
	# Change bullet type
	if Input.is_action_pressed("use_bullet_1"):
		change_bullet(1)
	if Input.is_action_pressed("use_bullet_2"):
		change_bullet(2)
	if Input.is_action_pressed("use_bullet_3"):
		change_bullet(3)

# Remove?
func apply_friction(delta):
	velocity -= velocity * friction * delta

func _on_base_ammo_updated(type):
	if type == "mg" and abilities.has("machine_gun"):
		load_ability("machine_gun").mg_ammo_storage += 1
		ammo_updated.emit(machine_gun_bullet, load_ability("machine_gun").mg_ammo_storage)
	else:
		ammo_storage += 1
		ammo_updated.emit(heavy_bullet, ammo_storage)


func _on_shoot_signal(bullet, _position, _direction):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	# Check what type of bullet was shot
	if bullet_scene_path.match("*player_bullet*"):
		ammo_storage -= 1
		ammo_updated.emit(bullet, ammo_storage)
	if bullet_scene_path.match("*machine_gun_bullet*") and abilities.has("machine_gun"):
		load_ability("machine_gun").mg_ammo_storage -= 1
		ammo_updated.emit(machine_gun_bullet, load_ability("machine_gun").mg_ammo_storage)
