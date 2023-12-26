extends Node2D

@export var splash_damage = 10

@onready var particles = $Particles
@onready var particles_fire = $ParticlesFire

func _ready():
	particles.emitting = true
	particles_fire.emitting = true
	
func _process(delta):
	if !particles_fire.emitting:
		queue_free()

func _on_splash_radius_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(splash_damage)
