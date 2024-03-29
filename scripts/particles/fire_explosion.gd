extends Node2D

@export var burn_damage = 5

var audio_manager

@onready var particles_fire = $ParticlesFire
@onready var particles_fire_2 = $ParticlesFire2
@onready var splash_radius = $SplashRadius

func _ready():
	audio_manager = get_parent().get_parent().get_node("AudioManager")
	# Play sound effect
	audio_manager.play_sound("ExplosionSfx")
	
	particles_fire.emitting = true
	particles_fire_2.emitting = true

func _process(_delta):
	if !particles_fire_2.emitting:
		queue_free()

func _on_splash_radius_body_entered(body):
	if body.has_method("burn"):
		body.burn(burn_damage)

func _on_impact_duration_timeout():
	splash_radius.process_mode = PROCESS_MODE_DISABLED
	splash_radius.visible = false
