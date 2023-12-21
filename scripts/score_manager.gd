extends Node

var _score = 0

# Singleton accessor function
func _get_singleton():
	return self

# Get the current score
func get_score():
	return _score

# Set the score
func set_score(value):
	_score = value
