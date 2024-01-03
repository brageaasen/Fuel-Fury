class_name Fuel

extends "res://scripts/items/item.gd"

@onready var animation_player = $AnimationPlayer

func on_spawn():
	animation_player.play("idle")

func play_pickup_sound():
	audio_manager.play_random_sound(audio_manager.pick_up_sounds)

func on_pickup_item():
	player.add_to_inventory(Fuel)
