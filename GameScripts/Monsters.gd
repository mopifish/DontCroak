extends Node2D

onready var tween = $Tween

func _enemy_exiting_tree():
	var list = get_tree().get_nodes_in_group("Monster")
	var child
	if len(list) > 1:
		for mon in list:
			if mon.health > 0:
				child = mon
				tween.interpolate_property(child, "position", child.position, $pos_0.position, 0.5)
				tween.start()
