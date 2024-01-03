extends Node2D

@export var explosion_damage = 20

var audio_manager

@onready var particles = $Particles
@onready var splash_radius = $SplashRadius

func _ready():
	audio_manager = get_parent().get_parent().get_node("AudioManager")
	# Play sound effect
	audio_manager.play_sound("ExplosionSfx")
	particles.emitting = true
func _process(delta):
	if !particles.emitting:
		queue_free()

func _on_splash_radius_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(explosion_damage)


func _on_impact_duration_timeout():
	splash_radius.process_mode = PROCESS_MODE_DISABLED
	splash_radius.visible = false
