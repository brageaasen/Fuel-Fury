extends Node2D

var enemy_list = [
	preload("res://scenes/enemy/enemy_tank.tscn")
]

func _on_spawn_timer_timeout():
	var enemy_to_spawn = randi_range(0, enemy_list.size() - 1)
	var enemy_scene = enemy_list[enemy_to_spawn].instantiate()
	enemy_scene.position = self.position
	add_child(enemy_scene)
	
	var nodes = get_parent().get_tree().get_nodes_in_group("spawner")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	self.position = position
