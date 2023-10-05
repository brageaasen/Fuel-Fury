extends Area2D

signal ammo_updated


# Called when the node enters the scene tree for the first time.
func _ready():
	$AmmoFillTimer.start()
	$AmmoFillTimer.set_paused(true)


func _on_ammo_fill_timer_timeout():
	ammo_updated.emit()

# JALLALØSNING BÆBUBÆBU
# Skulle brukt body_entered signalet men fikk det ikke til å funke.
# Lagde derfor en Area2D i Player, som dette interagerer med. I know, shitty.
# Den ideelle løsningen er å få body_entered til å funke, og få den til å sjekke at det er spilleren.
# Timeren skal kun kjøre når det er spilleren som er inni. 
# Sånn det er nå, så er for eksempel bullets samme som spilleren, 
# og det fucker med timeren å skyte når man er i basen.
func _on_area_entered(area):
	print("Area entered")
	$AmmoFillTimer.set_paused(false)


func _on_area_exited(area):
	print("Area exited")
	$AmmoFillTimer.set_paused(true)
