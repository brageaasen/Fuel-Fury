extends Control

var player # Reference to the player node
var possible_abilities
var current_abilities
@onready var ability_choice_1 = $AbilityChoice1

func _ready():
	player = get_node("/root/MainScene/Player")
	possible_abilities = {"machine_gun" : player.load_ability("machine_gun")}
	current_abilities = player.abilities
	print(player)
	print(player.load_ability("machine_gun"))

func update_healthbar(value):
	var tween = create_tween()
	tween.tween_property($HealthBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)
	$Health.text = "HP: " + str(value)

func update_experiencebar(value, level):
	var tween = create_tween()
	tween.tween_property($ExperienceBar, "value", value, 0.2).set_trans(Tween.TRANS_LINEAR)
	$Level.text = "Level: " + str(level)

func _on_player_ammo_updated(bullet, ammo_count):
	var bullet_scene_path = bullet.get_path().get_file()
	if bullet_scene_path.match("*player_bullet*"):
		$AmmoStorage.text = "Ammo: " + str(ammo_count)
	elif bullet_scene_path.match("*machine_gun_bullet*"):
		$MachineGunAmmoStorage.text = "Ammo: " + str(ammo_count)



# Abilities

var abilities_to_display = []

func _on_player_leveled_up():
	var count = 0
	while count < 3:
		# Get random new ability
		var random_ability = possible_abilities.keys()[randi() % possible_abilities.size()]
		# Check if player already has the ability
		var ability = possible_abilities[random_ability]
		if not current_abilities.has(ability):
			abilities_to_display.append(ability)
			count += 1
	
	# Display abilities
	ability_choice_1.text = abilities_to_display[0].title
	ability_choice_1.icon = abilities_to_display[0].image
	# TODO: Do the same for rest of the buttons
	
	# When done
	count = 0


func _on_ability_choice_1_pressed():
	player.abilities[abilities_to_display[0]._name] = abilities_to_display[0]
	# Reset new abilities list
	abilities_to_display = []
