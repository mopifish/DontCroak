extends "res://Usables/Usable.gd"

func use():
	LevelData.room_scenes["CheckPoint"] = world.room
	score_increase = 0
	$AnimationPlayer.play("Use")
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/checkpoint.wav", world.audioStreamPlayer)
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Flicker")
