extends Camera2D

@export var shake_base_amount : float = 1.0
@export var shake_dampening : float = 0.075

var shake_amount : float = 0.0

func _process(delta):
	if shake_amount > 0:
		position.x = randf_range(-shake_base_amount, shake_base_amount) * shake_amount
		position.y = randf_range(-shake_base_amount, shake_base_amount) * shake_amount
		shake_amount = lerp(shake_amount, 0.0, shake_dampening)
	else:
		position = Vector2(0, 0)

func shake(magnitude : float):
	shake_amount += magnitude
