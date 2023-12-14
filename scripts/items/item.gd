extends Area2D

var player # Reference to the player node or position

func _ready():
	player = get_node("/root/MainScene/Player")

func _on_pickup_radius_body_entered(body):
	if body.name == "Player":
		on_pickup_item()
		play_pickup_sound()
		queue_free()


func play_pickup_sound():
	pass

func on_pickup_item():
	pass
