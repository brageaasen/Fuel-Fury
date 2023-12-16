extends AnimatedSprite2D

var rotation_speed = 1.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	play("idle")

func _process(delta):
	global_position = get_global_mouse_position()
	var rotation_direction = 1
	rotation += rotation_speed * rotation_direction * delta
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
		play("click")
	if Input.is_action_just_released("left_click") or Input.is_action_just_released("right_click"):
		play("idle")
