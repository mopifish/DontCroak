extends "res://Items/Item.gd"

onready var level = $CanvasLayer/Tutorial setget set_level
onready var map_rooms = level.get_children()
onready var current_room = level.get_node("current_room")

func set_level(value):
	level = value
	map_rooms = level.get_children()
	current_room = level.get_node("current_room")

func use():
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/read_paper.wav", audioStreamPlayer)
	level.visible = not level.visible
	
	world.drop_button.disabled = true
	world.bag_button.disabled = not world.bag_button.disabled
	
	world.up_arrow.disabled = true
	world.down_arrow.disabled = true
	world.left_arrow.disabled = true
	world.right_arrow.disabled = true
	
	if not level.visible:
		world.disable_buttons()

func update_map(room_name):
	for room in map_rooms:
		if room.name == room_name:
			room.visible = true
			current_room.position = room.position
