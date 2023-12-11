extends "res://scripts/tanks/Tank.gd"

@export var ammo_storage : int = 30
@export var mg_ammo_storage : int = 120
var heavy_bullet : PackedScene = load( "res://scenes/bullets/PlayerBullet.tscn" )
var machine_gun_bullet : PackedScene = load( "res://scenes/bullets/MachineGunBullet.tscn" )

signal ammo_updated # Signal for HUD

func _ready():
	super._ready()
	ammo_updated.emit(heavy_bullet, ammo_storage)
	ammo_updated.emit(machine_gun_bullet, mg_ammo_storage)

# Move and attack with player
func control(delta):
	$Weapon.look_at(get_global_mouse_position())
	var rotation_direction = 0
	if Input.is_action_pressed("turn_right"):
		rotation_direction += 1
	if Input.is_action_pressed("turn_left"):
		rotation_direction -= 1
	rotation += rotation_speed * rotation_direction * delta
	velocity = Vector2()
	if Input.is_action_pressed("forward"):
		velocity = Vector2(speed, 0).rotated(rotation)
	if Input.is_action_pressed("back"):
		velocity = Vector2(-speed/2, 0).rotated(rotation)
		
	# Make seperate ammo storage for Machine Gun (MG) / Gun
	if Input.is_action_pressed("left_click"):
		if mg_ammo_storage > 0:
			shoot(machine_gun_bullet, "MG")
	if Input.is_action_pressed("right_click"):
		if ammo_storage > 0:
			shoot(heavy_bullet, "Gun")


func _on_base_ammo_updated():
	ammo_storage += 1
	mg_ammo_storage += 1
	ammo_updated.emit(heavy_bullet, ammo_storage)
	ammo_updated.emit(machine_gun_bullet, mg_ammo_storage)


func _on_shoot_signal(bullet, _position, _direction):
	# Find path of bullet scene
	var bullet_scene_path = bullet.get_path().get_file()
	
	# Check what type of bullet was shot
	if bullet_scene_path.match("*PlayerBullet*"):
		ammo_storage -= 1
		ammo_updated.emit(bullet, ammo_storage)
	elif bullet_scene_path.match("*MachineGunBullet*"):
		mg_ammo_storage -= 1
		ammo_updated.emit(bullet, mg_ammo_storage)
