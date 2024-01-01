class_name Heart

extends "res://scripts/items/item.gd"

@export var health_gain = 10

@onready var animation_player = $AnimationPlayer

func on_spawn():
	animation_player.play("idle")

func play_pickup_sound():
	pass

func on_pickup_item():
	player.gain_health(health_gain)
