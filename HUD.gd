extends Control

func update_ammo(ammo_count):
	$AmmoStorage.text = "Ammo: " + str(ammo_count)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_ammo_updated():
	pass # Replace with function body.
