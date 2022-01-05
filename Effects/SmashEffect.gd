extends AnimatedSprite

func _on_SmashEffect_animation_finished():
	queue_free()
