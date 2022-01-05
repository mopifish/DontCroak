extends Node

func play(sound, audioStreamPlayer):
	sound = load(sound)
	audioStreamPlayer.stream = sound
	audioStreamPlayer.play()
