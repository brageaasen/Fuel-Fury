extends Area2D

signal ammo_updated
signal entered_base

@export var ammo_refill_time : float
@export var MG_ammo_refill_time : float

func _ready():
	# Set refill time
	$AmmoFillTimer.wait_time = ammo_refill_time
	$MGAmmoFillTimer.wait_time = MG_ammo_refill_time
	# Start timers
	$AmmoFillTimer.start()
	$MGAmmoFillTimer.start()
	$AmmoFillTimer.set_paused(true)
	$MGAmmoFillTimer.set_paused(true)


func _process(_delta):
	# Play danger icon animation of value is less than or equal 30% of max value
	if $FuelContainer/FuelBar.value / $FuelContainer/FuelBar.max_value * 100 <= 30:
		$DangerIcon/AnimationPlayer.play("pulsate")
		$DangerIcon.visible = true
	else:
		$DangerIcon/AnimationPlayer.stop()
		$DangerIcon.visible = false
	
	# If player is inside the base, emit refuel signal
	if inside_base:
		emit_signal("entered_base")

func update_fuel_container(value):
	var tween = create_tween()
	tween.tween_property($FuelContainer/FuelBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)

func _on_ammo_fill_timer_timeout():
	ammo_updated.emit("heavy")

func _on_mg_ammo_fill_timer_timeout():
	ammo_updated.emit("mg")

var inside_base = false
func _on_body_entered(body):
	if body.name == "Player":
		inside_base = true
	$AmmoFillTimer.set_paused(false)
	$MGAmmoFillTimer.set_paused(false)

func _on_body_exited(body):
	if body.name == "Player":
		inside_base = false
	$AmmoFillTimer.set_paused(true)
	$MGAmmoFillTimer.set_paused(true)
