extends Area2D

var player # Reference to the player node or position
@export var should_rotate : bool

@export var lifetime : float = 4
@export var speed = 10

var velocity = Vector2()

func _ready():
	player = get_node("/root/MainScene/Player")

func _process(delta):
	position += velocity * delta
	velocity *= 0.99
	
	# Make sprite more transparent to show lifetime left
	if $Lifetime.time_left < $Lifetime.wait_time / 2:
		$Body.modulate.a = 0.8

func spawn(_position, _direction):
	self.on_spawn()
	position = _position
	if should_rotate:
		rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	velocity = _direction * speed

func _on_lifetime_timeout():
	queue_free()

func _on_pickup_radius_body_entered(body):
	if body.name == "Player":
		on_pickup_item()
		play_pickup_sound()
		queue_free()

func on_spawn():
	pass

func play_pickup_sound():
	pass

func on_pickup_item():
	pass

