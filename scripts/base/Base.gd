extends Area2D

signal health_changed
signal died
signal ammo_updated

@export var max_health : int
var health
var alive = true

func _ready():
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	$AmmoFillTimer.start()
	$AmmoFillTimer.set_paused(true)


func take_damage(damage):
	health -= damage
	emit_signal("health_changed", health * 100/max_health)
	if (health <= 0):
		alive = false
		die() # Destroy object
		emit_signal("died") # No one catches this signal yet

func die():
	queue_free() # Should maybe not queue free the player object?


func update_healthbar(value):
	var tween = create_tween()
	tween.tween_property($Container/HealthBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)
	$Container/Health.text = "HP: " + str(value)


func _on_ammo_fill_timer_timeout():
	ammo_updated.emit()


func _on_body_entered(body):
	$AmmoFillTimer.set_paused(false)


func _on_body_exited(body):
	$AmmoFillTimer.set_paused(true)
