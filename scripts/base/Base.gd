extends Area2D

signal ammo_updated


func _ready():
	$AmmoFillTimer.start()
	$AmmoFillTimer.set_paused(true)


func _on_ammo_fill_timer_timeout():
	ammo_updated.emit()


func _on_body_entered(body):
	$AmmoFillTimer.set_paused(false)


func _on_body_exited(body):
	$AmmoFillTimer.set_paused(true)
