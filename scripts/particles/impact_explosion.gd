extends Node2D

@export var explosion_damage = 20

@onready var particles = $Particles

func _ready():
	particles.emitting = true
func _process(delta):
	if !particles.emitting:
		queue_free()

func _on_splash_radius_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(explosion_damage)
