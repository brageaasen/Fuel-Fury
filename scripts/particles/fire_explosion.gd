extends Node2D

@export var burn_damage = 5

@onready var particles = $Particles
@onready var particles_fire = $ParticlesFire
@onready var particles_fire_2 = $ParticlesFire2

func _ready():
	particles.emitting = true
	particles_fire.emitting = true
	particles_fire_2.emitting = true

func _process(delta):
	if !particles_fire.emitting:
		queue_free()

func _on_splash_radius_body_entered(body):
	if body.has_method("burn"):
		body.burn(burn_damage)
