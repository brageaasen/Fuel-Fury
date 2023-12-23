class_name Experience

extends "res://scripts/items/item.gd"

@export var experience = 1
@onready var animation_player = $AnimationPlayer

func on_spawn():
	animation_player.play("idle")

func play_pickup_sound():
	audio_manager.play_sound("PickUpSfx")

func on_pickup_item():
	player.gain_experience(experience)
