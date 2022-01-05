extends Node2D

onready var world = get_tree().current_scene
onready var tween = $Tween
onready var audioStreamPlayer = $AudioStreamPlayer
export var score_increase:int

export(String, "Weapon", "Item", "Tool") var Class

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("Resting")

func move_to_bag():
	tween.interpolate_property(self, "position", position, Vector2(12,37), 0.5)
	tween.start()
	if Class == "Tool" or Class == "Weapon":
		world.score.score += score_increase

func play_sound(sound):
	AudioHandler.play(sound, world.audioStreamPlayer)
