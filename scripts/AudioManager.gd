class_name AudioManager

extends Node

#@export var global_volume : float = 0.0
var sounds = []
var music = []

var pick_up_sounds = []
var gain_ability_sounds = []
var shoot_sounds = []

func _ready():
	for child_node in get_children():
		var _name = child_node.get_name()
		if _name.find("ShootMG") > -1:
			shoot_sounds.append(child_node)
		if _name.find("GainAbility") > -1:
			gain_ability_sounds.append(child_node)
		if _name.find("PickUp") > -1:
			pick_up_sounds.append(child_node)
		if _name.find("Sfx") > -1:
			sounds.append(child_node)
		elif _name.find("Music") > -1:
			music.append(child_node)

func play_sound(name: String):
	for sound_node in sounds:
		if sound_node.get_name() == name:
			var sound = sound_node
			if sound.is_playing():
				sound.stop()  # Stop the sound if it's already playing
			sound.play()
			return  # Exit the loop once the sound is found and played
	print("Sound", name, "not found in the list of sounds.")

func play_music(name: String):
	for music_node in music:
		if music_node.get_name() == name:
			var sound = music_node
			if sound.is_playing():
				sound.stop()  # Stop the music if it's already playing
			sound.play()
			return  # Exit the loop once the sound is found and played
	print("Sound", name, "not found in the list of music.")

# Play random sound from list
func play_random_sound(list):
	list.pick_random().play()
