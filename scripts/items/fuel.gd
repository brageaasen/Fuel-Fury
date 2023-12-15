extends "res://scripts/items/item.gd"

@export var fuel = 1
@onready var animation_player = $AnimationPlayer

func on_spawn():
	animation_player.play("idle")

func play_pickup_sound():
	pass

func on_pickup_item():
	player.gain_fuel(fuel)
