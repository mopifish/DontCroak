extends "res://Items/Item.gd"

func _on_Candle_tree_entered():
	#yield(get_tree().create_timer(0.1), "timeout") # heehe oopsy messy. But makes camera wait to fully enter scene tree and get parented before continuing
	#world.room.get_node("DarkTexture").visible = not world.is_light_source() and world.room.is_dark
	pass
