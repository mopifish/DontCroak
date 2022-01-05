extends Node2D

export(String, FILE, "*.tscn") var left_door
export(String, FILE, "*.tscn") var right_door
export(String, FILE, "*.tscn") var front_door 
export(String, FILE, "*.tscn") var back_door 

export(bool) var is_dark

var open_wall = preload("res://Lowrez Dungeoncrawl Assets/Rooms/walls/open_wall.png")

func _ready():
	light_room()
	
	LevelData.room_scenes[name] = self
	if LevelData.room_scenes["CheckPoint"] == null:
		LevelData.room_scenes["CheckPoint"] = self

func is_blocked(door):
	for child in $Usables.get_children():
		if child.side == door and child.blocks_door:
			return true

func light_room():
	$LightTexture.visible = is_dark
	$DarkTexture.visible = is_dark
	if get_tree().current_scene.is_light_source() and is_dark:
		$AnimationPlayer.play("Flicker")
	else:
		$AnimationPlayer.play("Resting")
