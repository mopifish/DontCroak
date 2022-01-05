extends "res://Rooms/Room.gd"

onready var world = get_parent().get_parent()

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	world.current_button = $Live
	world.state = world.WIN
	
	$Label.text = "FINAL SCORE: " + str(get_parent().get_parent().score.score)
	$AnimationPlayer.play("Fade out")

func _on_Live_pressed():
	$Live.pressed = true
	if name == "Secret":
		$AnimationPlayer.play("Exit")
		yield($AnimationPlayer, "animation_finished")
	else:
		EffectHandler.instance_fade_effect(world)
		yield(get_tree().create_timer(0.5), "timeout")
	LevelData.room_scenes = {CheckPoint = null}
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().paused = false

func play_sound(sound):
	AudioHandler.play(sound, world.audioStreamPlayer)
