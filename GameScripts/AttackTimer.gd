extends Timer


# warning-ignore:unused_argument
func _process(delta):
	if not is_stopped():
		get_parent().get_node("AttackButton").modulate.a8 = 255*(1 - time_left/wait_time)
