class_name Transitioner

extends Control

@onready var fade_circle = $FadeCircle
@onready var animation_player = $AnimationPlayer

func _ready():
	fade_circle.visible = false

func set_next_animation(animation : String):
	if animation == "fade_out":
		animation_player.queue("fade_out")
	else:
		animation_player.queue("fade_in")
