extends "res://Items/Item.gd"

func use():
	$AnimationPlayer.play("Use")
	world.bag_button.emit_signal("toggled", false)
	world.bag_button.pressed = false
	EffectHandler.instance_smash_effect(world.get_node("EffectPosition"))
	AudioHandler.play("res://Lowrez Dungeoncrawl Assets/Sounds/smash2.wav", world.audioStreamPlayer)
	for wall in get_tree().get_nodes_in_group("SecretWall"):
		wall.use()
