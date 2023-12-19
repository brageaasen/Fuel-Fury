extends Control

var player # Reference to the player node
var possible_abilities
var current_abilities

func _ready():
	player = get_node("/root/MainScene/Player")
	possible_abilities = {"machine_gun" : player.load_ability("machine_gun")}
	current_abilities = player.abilities
	# Connect button signals
	$AbilityChoice0/Button.connect("pressed", _on_ability_choice_0_pressed)
	$AbilityChoice1/Button.connect("pressed", _on_ability_choice_1_pressed)
	$AbilityChoice2/Button.connect("pressed", _on_ability_choice_2_pressed)

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



## Abilities

var abilities_to_display = []

func _on_player_leveled_up():
	var count = 0
	if possible_abilities.size() != 0:
		while count < 3:
			# Get random new ability
			var random_ability = possible_abilities.keys()[randi() % possible_abilities.size()]
			# Check if player already has the ability
			var ability = possible_abilities[random_ability]
			
			if not current_abilities.has(ability): # and !abilities_to_display.has(ability):
				print(abilities_to_display.has(ability))
				abilities_to_display.append(ability)
				count += 1
			
		# Display abilities
		for i in range(0, 3): # Loop from 0 to 2 inclusive
			# Access each AbilityChoice node dynamically
			var ability_choice = get_node("AbilityChoice" + str(i))
			if abilities_to_display[i] != null:
				# Set visibility to true for the current AbilityChoice
				ability_choice.visible = true
				
				# Set properties based on the index of ability
				ability_choice.get_node("Button/Icon/Name").text = abilities_to_display[i].title
				ability_choice.get_node("Button/Icon").texture = abilities_to_display[i].image

func ability_chosen(ability_number):
	# Add ability to players ability list
	player.abilities[abilities_to_display[ability_number]._name] = abilities_to_display[ability_number]
	# Remove ability from possible abilities
	possible_abilities.erase(abilities_to_display[ability_number]._name)
	
	# Make all buttons non visble to the player
	for i in range(0, 3): # Loop from 0 to 2 inclusive
		# Access each AbilityChoice node dynamically
		var ability_choice = get_node("AbilityChoice" + str(i))
		if abilities_to_display[i] != null:
			# Set visibility to false for the current AbilityChoice
			ability_choice.visible = false
			
			# Set properties based on the index of ability
			ability_choice.get_node("Button/Icon/Name").text = ""
			ability_choice.get_node("Button/Icon").texture = null
	# Reset new abilities list
	abilities_to_display = []

func ability_hover(ability):
	# Enable infobox
	$InfoContainer/InfoBox.visible = true
	# Set the label's text
	$InfoContainer/InfoBox/MarginContainer/Info.text = abilities_to_display[ability].info

func ability_non_hover():
	# Disable infobox
	$InfoContainer/InfoBox.visible = false
	# Reset the label's text
	$InfoContainer/InfoBox/MarginContainer/Info.text = ""

# Signals for ability button 0
func _on_ability_choice_0_pressed():
	ability_chosen(0)

func _on_ability_choice_0_mouse_entered():
	ability_hover(0)

func _on_ability_choice_0_mouse_exited():
	ability_non_hover()

# Signals for ability button 1
func _on_ability_choice_1_pressed():
	ability_chosen(1)

func _on_ability_choice_1_mouse_entered():
	ability_hover(1)

func _on_ability_choice_1_mouse_exited():
	ability_non_hover()

# Signals for ability button 2
func _on_ability_choice_2_pressed():
	ability_chosen(2)

func _on_ability_choice_2_mouse_entered():
	ability_hover(2)

func _on_ability_choice_2_mouse_exited():
	ability_non_hover()



func _on_control_mouse_entered():
	print("ENTERED")


func _on_control_2_mouse_entered():
	print("ENTERED")
