extends "res://Items/Item.gd"

export var damage_increase:float = 0

func use():
	if world.get_node("Player").weapon != null:
		var weapon = world.get_node("Player").weapon
		weapon.damage += damage_increase
		AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/whetstone.wav", world.audioStreamPlayer)
		$AnimationPlayer.play("Use")
		world.use_button.disabled = true
		world.drop_button.disabled = true
		yield($AnimationPlayer, "animation_finished")
		world.disable_buttons()
