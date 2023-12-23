extends Node2D

@onready var particles = $Particles

func _ready():
	particles.emitting = true
