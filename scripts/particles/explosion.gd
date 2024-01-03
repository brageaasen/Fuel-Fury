extends Node2D

@onready var particles = $Particles

var audio_manager
 
func _ready():
	audio_manager = get_parent().get_parent().get_node("AudioManager")
	# Play sound effect
	audio_manager.play_sound("ExplosionSfx")
	
	particles.emitting = true
