extends Area2D

signal ammo_updated


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: CharacterBody2D):
	hide()
	print("entered body")


func _on_ammo_fill_timer_timeout():
	ammo_updated.emit()


func _on_area_entered(area):
	print("Area entered")
	$AmmoFillTimer.start()
	emit_signal("ammo_updated")


func _on_area_exited(area):
	print("Area exited")
	$AmmoFillTimer.stop()

