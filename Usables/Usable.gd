extends Node2D

onready var world = get_tree().current_scene
onready var room = world.get_node("Rooms").get_child(0)
onready var player = world.get_node("Player")
onready var bag = world.get_node("Bag")

export(String, "LeftWall", "RightWall", "FrontWall") var side
export(bool) var blocks_door
export(String, FILE, "*.tscn") var required_item
export var score_increase:int

func has_required_item():
	return bag.has(required_item)

func play_sound(sound):
	AudioHandler.play(sound, world.audioStreamPlayer)
