extends "res://Items/Item.gd"

export var defense_amount:float = 0

func use():
	world.get_node("Player").defense += defense_amount
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/equip_ring.wav", world.audioStreamPlayer)
	$AnimationPlayer.play("Use")
	world.use_button.disabled = true
	world.drop_button.disabled = true
	yield($AnimationPlayer, "animation_finished")
	world.disable_buttons()
