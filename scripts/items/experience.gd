extends "res://scripts/items/item.gd"

@export var experience = 1

func play_pickup_sound():
	pass

func on_pickup_item():
	player.gain_experience(experience)
