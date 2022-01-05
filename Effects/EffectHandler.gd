extends Node

const slash_effect = preload("res://Effects/SlashEffect.tscn")
const smash_effect = preload("res://Effects/SmashEffect.tscn")
const fade_effect = preload("res://Effects/FadeToBlack.tscn")

func instance_slash_effect(parent):
	var effect = slash_effect.instance()
	parent.add_child(effect)
	effect.frame = 0

func instance_smash_effect(parent):
	var effect = smash_effect.instance()
	parent.add_child(effect)
	effect.frame = 0

func instance_fade_effect(parent, speed = 1):
	var effect = fade_effect.instance()
	effect.get_node("AnimationPlayer").playback_speed = speed
	parent.add_child(effect)
