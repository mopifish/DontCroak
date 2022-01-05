extends "res://Usables/Usable.gd"

func use():
	if has_required_item():
		if required_item == "res://Items/Key.tscn":
			var key = bag.get("res://Items/Key.tscn")
			key.queue_free()
		world.score.score += score_increase
		$AnimationPlayer.play("Open")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_parent().remove_child(self)
		queue_free()
		world.disable_buttons()
	else:
		$AnimationPlayer.play("Show")
