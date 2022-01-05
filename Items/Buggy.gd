extends "res://Items/Item.gd"

export var heal_amount = 0

func use():
	if world.get_node("Player").health < world.get_node("Player").max_health:
		world.get_node("Player").health += heal_amount
		$AnimationPlayer.play("Eat")
		world.use_button.disabled = true
		world.drop_button.disabled = true
		yield($AnimationPlayer, "animation_finished")
		world.disable_buttons()
