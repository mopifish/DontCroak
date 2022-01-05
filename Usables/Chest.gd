extends "res://Usables/Usable.gd"

export(String, FILE, "*.tscn") var contained_item
var opened = false

func use():
	if not opened:
		$AnimationPlayer.play("Open")
		opened = true

func instance_item():
	var item = load(contained_item).instance()
	get_parent().get_parent().get_node("Items").add_child(item)
	item.get_node("AnimationPlayer").play("Bounce")
	var new_position
	for i in range(0,4):
		var j = 4
		while j < world.items.get_child_count():
			if world.items.get_child(j).position == world.items.get_child(i).position:
				i += 1
				j = 4
			else:
				j += 1
		new_position = world.items.get_child(i).position
		break
	item.tween.interpolate_property(item, "position", position, new_position, 0.5)
	item.tween.start()
	
	
