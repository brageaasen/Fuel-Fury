extends Area2D

signal health_changed
signal died
signal ammo_updated
signal entered_base

@export var ammo_refill_time : float
@export var MG_ammo_refill_time : float
@export var max_health : int
var health
var alive = true

func _ready():
	# Keep / Remove health for base?
	health = max_health
	emit_signal("health_changed", health * 100/max_health)
	
	# Set refill time
	$AmmoFillTimer.wait_time = ammo_refill_time
	$MGAmmoFillTimer.wait_time = MG_ammo_refill_time
	# Start timers
	$AmmoFillTimer.start()
	$MGAmmoFillTimer.start()
	$AmmoFillTimer.set_paused(true)
	$MGAmmoFillTimer.set_paused(true)

# Keep / Remove health for base?
func take_damage(damage):
	health -= damage
	emit_signal("health_changed", health * 100/max_health)
	if (health <= 0):
		alive = false
		die() # Destroy object
		emit_signal("died") # No one catches this signal yet

# Keep / Remove health for base?
func die():
	queue_free() # Should maybe not queue free the player object?w

func update_fuel_container(value):
	var tween = create_tween()
	tween.tween_property($FuelContainer/FuelBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)

func _on_ammo_fill_timer_timeout():
	ammo_updated.emit("heavy")

func _on_mg_ammo_fill_timer_timeout():
	ammo_updated.emit("mg")


func _on_body_entered(body):
	emit_signal("entered_base")
	$AmmoFillTimer.set_paused(false)
	$MGAmmoFillTimer.set_paused(false)


func _on_body_exited(body):
	$AmmoFillTimer.set_paused(true)
	$MGAmmoFillTimer.set_paused(true)
