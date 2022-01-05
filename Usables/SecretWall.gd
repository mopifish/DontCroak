extends "res://Usables/Usable.gd"

func use():
	$AnimationPlayer.play("Open")
	yield($AnimationPlayer, "animation_finished")
	blocks_door = false
	world.disable_buttons()
