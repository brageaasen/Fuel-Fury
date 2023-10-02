extends "res://tanks/Tank.gd"

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
		shoot()
		print(gun_cooldown)
