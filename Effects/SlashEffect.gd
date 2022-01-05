extends AnimatedSprite

func _on_SlashEffect_animation_finished():
	queue_free()
