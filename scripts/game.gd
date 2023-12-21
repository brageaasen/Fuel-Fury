extends Node

@export var time_before_restart = 5

var player
var possible_abilities
var current_abilities

@onready var animation_player = $CanvasLayer/StartMenu/AnimationPlayer
@onready var transitions = $CanvasLayer/Transitions
@onready var restart_timer = $RestartTimer

func _ready():
	get_tree().paused = true
	restart_timer.wait_time = time_before_restart
	player = get_node("/root/Game/MainScene/Player")
	possible_abilities = ["machine_gun", "loot_magnet"]
	current_abilities = player.abilities
	# Connect player signals to self
	player.connect("died", _on_player_death)
	player.connect("leveled_up", _on_player_leveled_up)
	# Connect button signals
	$CanvasLayer/AbilityMenu/AbilityChoice0/Button.connect("pressed", _on_ability_choice_0_pressed)
	$CanvasLayer/AbilityMenu/AbilityChoice1/Button.connect("pressed", _on_ability_choice_1_pressed)
	$CanvasLayer/AbilityMenu/AbilityChoice2/Button.connect("pressed", _on_ability_choice_2_pressed)

# For pause menu ?
func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var current_value = get_tree().paused
		#get_tree().paused = !current_value

func _on_player_death(type):
	# Fade out
	transitions.set_next_animation("fade_out")
	if type == "death":
		$CanvasLayer/GameEndDeathText/AnimationPlayer.play("fade_in")
		$CanvasLayer/GameEndDeathText.visible = true
	else:
		$CanvasLayer/GameEndFuelText/AnimationPlayer.play("fade_in")
		$CanvasLayer/GameEndFuelText.visible = true
	print(get_tree())
	restart_timer.start()

func _on_restart_timer_timeout():
	get_tree().reload_current_scene()

func _on_start_button_pressed():
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
	get_node("CanvasLayer/StartMenu/HoverAnimation").visible = true
	get_node("CanvasLayer/StartMenu/HoverAnimation").play("hover")
	
func _on_start_button_mouse_exited():
	get_node("CanvasLayer/StartMenu/HoverAnimation").visible = false





## Abilities

var abilities_to_display = []

func _on_player_leveled_up():
	get_node("CanvasLayer/AbilityMenu").visible = true
	get_tree().paused = true
	var count = 0
	if possible_abilities.size() != 0:
		while count < 3:
			# Get random new ability
			var random_ability = possible_abilities[randi() % possible_abilities.size()]
			# Check if player already has the ability
			if not current_abilities.has(random_ability): # and not abilities_to_display.has(ability):
				abilities_to_display.append(random_ability)
				count += 1
			
		# Display abilities
		for i in range(0, 3): # Loop from 0 to 2 inclusive
			# Access each AbilityChoice node dynamically
			var ability_choice = get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(i))
			print(ability_choice)
			if abilities_to_display[i] != null:
				# Set visibility to true for the current AbilityChoice
				ability_choice.visible = true
				
				# Set properties based on the index of ability
				ability_choice.get_node("Button/Icon/Name").text = player.load_ability(abilities_to_display[i]).title
				ability_choice.get_node("Button/Icon").texture = player.load_ability(abilities_to_display[i]).image

func ability_chosen(ability_number):
	get_node("CanvasLayer/AbilityMenu").visible = false
	get_tree().paused = false
	# Animation
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").play("click")
	# TODO: Add screen shake when click
	
	# Add ability to players ability list
	player.abilities.append(abilities_to_display[ability_number])
	# Remove ability from possible abilities
	possible_abilities.erase(abilities_to_display[ability_number])
	
	# Make all buttons non visble to the player
	for i in range(0, 3): # Loop from 0 to 2 inclusive
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

func ability_hover(ability_number):
	# Animation
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").visible = true
	get_node("CanvasLayer/AbilityMenu/AbilityChoice" + str(ability_number)).get_node("HoverAnimation").play("hover")
	# Enable infobox
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox.visible = true
	# Set the label's text
	$CanvasLayer/AbilityMenu/InfoContainer/InfoBox/MarginContainer/Info.text = player.load_ability(abilities_to_display[ability_number]).info

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




