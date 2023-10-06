extends Control


func _on_player_ammo_updated(ammo_count):
	$AmmoStorage.text = "Ammo: " + str(ammo_count)

# TODO:
# - Lag inventory rendering
# - Lag indikator for hvor mye ammo man har liggende i inventory, og hvor mye som er ladd
# - Få spillet til å tilpasse seg skjermen bedre.
