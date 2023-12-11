extends Area2D

signal explode_particles

@export var Explosion_particles : PackedScene
@export var speed: int
@export var damage: int
@export var lifetime: float

var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed

func _process(delta):
	position += velocity * delta

# Explode bullet
func explode():
	queue_free()
	emit_signal("explode_particles", Explosion_particles, position)

func _on_body_entered(body):
	explode()
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_lifetime_timeout():
	explode()
