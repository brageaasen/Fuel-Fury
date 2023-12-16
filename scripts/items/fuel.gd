class_name Fuel

extends "res://scripts/items/item.gd"

@onready var animation_player = $AnimationPlayer

func on_spawn():
	animation_player.play("idle")

func play_pickup_sound():
	pass

func on_pickup_item():
	player.add_to_inventory(Fuel)
