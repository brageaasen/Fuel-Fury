extends Node

@export var time_before_restart = 5

var player
var possible_abilities
var current_abilities
var score = 0

var level_to_activate_secret_ability = 13

@onready var audio_manager = $AudioManager
@onready var animation_player = $CanvasLayer/StartMenu/AnimationPlayer
@onready var hover_animation = $CanvasLayer/StartMenu/HoverAnimation
@onready var transitions = $CanvasLayer/Transitions
@onready var restart_timer = $RestartTimer
@onready var best_score = $CanvasLayer/BestScore
@onready var sound_menu = $CanvasLayer/SoundMenu


func _ready():
	get_tree().paused = true
	restart_timer.wait_time = time_before_restart
	player = get_node("/root/Game/MainScene/Player")
	possible_abilities = ["machine_gun", "loot_magnet", "gain_fuel", "larger_fuel_storage",
	"repair_kit", "more_health", "fire_projectile", "more_speed", "faster_ammo_recharge",
	"larger_bullets", "explosive_bullet"]
	current_abilities = player.abilities
	# Connect player signals to self
	player.connect("died", _on_player_death)
	player.connect("leveled_up", _on_player_leveled_up)
	# Connect button signals
	$CanvasLayer/AbilityMenu/AbilityChoice0/Button.connect("pressed", _on_ability_choice_0_pressed)
	$CanvasLayer/AbilityMenu/AbilityChoice1/Button.connect("pressed", _on_ability_choice_1_pressed)
	$CanvasLayer/AbilityMenu/AbilityChoice2/Button.connect("pressed", _on_ability_choice_2_pressed)
	$CanvasLayer/AbilityMenu/SecretAbility/Button.connect("pressed", _on_secret_ability_choice_pressed)
	best_score.text = "Best Score: " + str(ScoreManager.get_score())


func _on_player_death(type):
	# Check if should update score
	if score > ScoreManager.get_score():
		ScoreManager.set_score(score)
	# Fade out
	transitions.set_next_animation("fade_out")
	if type == "death":
		$CanvasLayer/GameEndDeathText/AnimationPlayer.play("fade_in")
		$CanvasLayer/GameEndDeathText.visible = true
	else:
		$CanvasLayer/GameEndFuelText/AnimationPlayer.play("fade_in")
		$CanvasLayer/GameEndFuelText.visible = true
	restart_timer.start()

func _on_restart_timer_timeout():
	get_tree().reload_current_scene()
	best_score.visible = true

func _on_start_button_pressed():
	best_score.visible = false
	sound_menu.visible = false
	hover_animation.visible = false
	# Play audio
	audio_manager.play_sound("SelectSfx")
	audio_manager.play_music("Music")
	# Screen shake
	get_node("MainScene/MainCamera").shake(6)
	# Animations
	animation_player.play("fade_out_logo_and_start_button")
	transitions.set_next_animation("fade_in")
	get_tree().paused = false
	$CanvasLayer/StartMenu/Background.visible = false
	#$CanvasLayer/StartMenu.visible = false
	get_node("CanvasLayer/StartMenu/HoverAnimation").visible = false

func _on_start_button_mouse_entered():
	get_node("CanvasLayer/StartMenu/HoverAnimation").visible = false
	get_node("CanvasLayer/StartMenu/HoverAnimation").play("hover")
	
func _on_start_button_mouse_exited():
	get_node("CanvasLayer/StartMenu/HoverAnimation").visible = true


# Function to increase score
func increase_score(value):
	score += value
	save_score()

# Function to save the score
func save_score():
	ScoreManager.set_score(score)



## Abilities

var abilities_to_display = []
var iterations

func _on_player_leveled_up(level):
	if possible_abilities.size() == 0 and player.abilities.has("secret_ability"):
		return
	sound_menu.visible = true
	get_node("MainScene/AnimationPlayer").play("fade_to_black")
	get_node("CanvasLayer/AbilityMenu").visible = true
	get_node("CanvasLayer/AbilityMenu/LevelUp").visible = true
	get_node("CanvasLayer/AbilityMenu/LevelUp").get_node("AnimationPlayer").play("fade_in")
	get_tree().paused = true
	
	
	iterations = 3 # Default value for possible_abilities.size() >= 3
	match possible_abilities.size():
		0: iterations = 0
		1: iterations = 1
		2: iterations = 2
	var count = 0
	while count < iterations:
		if iterations == 0: break
		# Get random new ability
		var random_ability = possible_abilities[randi() % possible_abilities.size()]
		# Check if ability is already displayed
		if abilities_to_display.has(random_ability):
			continue
		# Check if player already has the ability
		if not current_abilities.has(random_ability):
			abilities_to_display.append(random_ability)
			count += 1
			
	# Display abilities
	for i in range(0, iterations): # Loop from 0 to iterations inclusive
		# Access each AbilityChoice node dynamically
		var ability_choice = get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(i))
		ability_choice.get_node("AnimationPlayer").play("fade_in")
		if abilities_to_display[i] != null:
			# Set visibility to true for the current AbilityChoice
			ability_choice.visible = true
			
			# Set properties based on the index of ability
			ability_choice.get_node("Button/Icon/Name").text = "[center]" + player.load_ability(abilities_to_display[i]).title
			ability_choice.get_node("Button/Icon").texture = player.load_ability(abilities_to_display[i]).image
	
	# Secret ability
	var secret_ability = get_node("CanvasLayer/AbilityMenu/SecretAbility")
	secret_ability.visible = true
	if player.level < level_to_activate_secret_ability:
		secret_ability.get_node("AnimationPlayer").play("fade_in")
	else:
		secret_ability.get_node("AnimationPlayer").play("fade_in_white")

func ability_chosen(ability_number):
	# Play audio
	audio_manager.play_random_sound(audio_manager.gain_ability_sounds)
	
	get_node("CanvasLayer/AbilityMenu").visible = false
	get_node("CanvasLayer/AbilityMenu/LevelUp").visible = false
	sound_menu.visible = false
	get_tree().paused = false
	# Animation
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").play("click")
	get_node("MainScene/AnimationPlayer").play("fade_from_black")
	
	get_node("MainScene/MainCamera").shake(1)
	
	# Execute ability
	player.load_ability(abilities_to_display[ability_number]).execute(player)
	# Add ability to players ability list
	player.abilities.append(abilities_to_display[ability_number])
	# Remove ability from possible abilities
	possible_abilities.erase(abilities_to_display[ability_number])
	
	# Make all current buttons non visble to the player
	for i in range(0, iterations): # Loop from 0 to iterations inclusive
		# Access each AbilityChoice node dynamically
		var ability_choice = get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(i))
		if abilities_to_display[i] != null:
			# Set visibility to false for the current AbilityChoice
			ability_choice.visible = false
			
			# Reset properties
			ability_choice.get_node("Button/Icon/Name").text = ""
			ability_choice.get_node("Button/Icon").texture = null
	# Reset new abilities list
	abilities_to_display = []
	ability_non_hover(ability_number)
	
	# Secret ability
	var secret_abiltiy = get_node("CanvasLayer/AbilityMenu/SecretAbility")
	secret_abiltiy.visible = false
	secret_abiltiy.get_node("HoverAnimation").visible = false

func ability_hover(ability_number):
	# Play sound SFX
	audio_manager.play_random_sound(audio_manager.hover_sounds)
	# Animation
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").visible = true
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").play("hover")
	# Enable infobox
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox.visible = true
	# Set the label's text
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = "[center]" + player.load_ability(abilities_to_display[ability_number]).info

func ability_non_hover(ability_number):
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").visible = false
	# Disable infobox
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox.visible = false
	# Reset the label's text
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = ""

# Signals for ability button 0
func _on_ability_choice_0_pressed():
	ability_chosen(0)

func _on_ability_choice_0_mouse_entered():
	ability_hover(0)

func _on_ability_choice_0_mouse_exited():
	ability_non_hover(0)

# Signals for ability button 1
func _on_ability_choice_1_pressed():
	ability_chosen(1)

func _on_ability_choice_1_mouse_entered():
	ability_hover(1)

func _on_ability_choice_1_mouse_exited():
	ability_non_hover(1)

# Signals for ability button 2
func _on_ability_choice_2_pressed():
	ability_chosen(2)

func _on_ability_choice_2_mouse_entered():
	ability_hover(2)

func _on_ability_choice_2_mouse_exited():
	ability_non_hover(2)


func _on_secret_ability_choice_pressed():
	if player.level < level_to_activate_secret_ability:
		return
	
	# Play audio
	audio_manager.play_random_sound(audio_manager.gain_ability_sounds)
	
	get_node("CanvasLayer/AbilityMenu").visible = false
	get_node("CanvasLayer/AbilityMenu/LevelUp").visible = false
	sound_menu.visible = false
	get_tree().paused = false
	# Animation
	get_node("CanvasLayer/AbilityMenu/SecretAbility").get_node("HoverAnimation").play("click")
	get_node("MainScene/AnimationPlayer").play("fade_from_black")
	
	get_node("MainScene/MainCamera").shake(1)
	
	# Execute ability
	player.load_ability("secret_ability").execute(player)
	# Add ability to players ability list
	player.abilities.append("secret_ability")
	
	# Make current button non visble to the player
	var ability_choice = get_node("CanvasLayer/AbilityMenu/SecretAbility")
	# Set visibility to false for the current AbilityChoice
	ability_choice.visible = false
	# Reset new abilities list
	abilities_to_display = []
	
	get_node("CanvasLayer/AbilityMenu/SecretAbility").get_node("HoverAnimation").visible = false
	# Disable infobox
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox.visible = false
	# Reset the label's text
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = ""


func _on_secret_ability_choice_mouse_entered():
	# Play sound SFX
	audio_manager.play_random_sound(audio_manager.hover_sounds)
	# Animation
	get_node("CanvasLayer/AbilityMenu/SecretAbility").get_node("HoverAnimation").visible = true
	get_node("CanvasLayer/AbilityMenu/SecretAbility").get_node("HoverAnimation").play("hover")
	# Enable infobox
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox.visible = true
	# Set the label's text
	if player.level < level_to_activate_secret_ability:
		$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = "[center]" + player.load_ability("secret_ability").info
	else:
		$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = "[center]What does this do?"

func _on_secret_ability_choice_mouse_exited():
	get_node("CanvasLayer/AbilityMenu/SecretAbility").get_node("HoverAnimation").visible = false
	# Disable infobox
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox.visible = false
	# Reset the label's text
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = ""
