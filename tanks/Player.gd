extends "res://tanks/Tank.gd"

var ammo_storage: int = 0

signal ammo_updated # Signal til HUD

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
	if Input.is_action_pressed("click"):
		if ammo_storage > 0:
			shoot()


func _on_base_ammo_updated():
	ammo_storage += 1
	ammo_updated.emit(ammo_storage)


# Litt bloat, men gadd ikke å implementere shoot anderledes.
func _on_shoot_signal(bullet, _position, _direction):
	ammo_storage -= 1
	ammo_updated.emit(ammo_storage)
