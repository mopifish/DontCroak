extends "res://Items/Item.gd"

export var damage = 0.0 setget set_damage
export(String, "Slash", "Smash") var damage_type
export var recovery_time:float

func use():
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/equip_weapon.wav", world.audioStreamPlayer)
	world.get_node("Player").weapon = self

func set_damage(value):
	damage = value
	if world != null:
		world.get_node("Player").attack = damage
