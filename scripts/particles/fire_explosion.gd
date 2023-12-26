extends Node2D

@onready var particles = $Particles
@onready var particles_fire = $ParticlesFire

func _ready():
	particles.emitting = true
	particles_fire.emitting = true
