extends Area2D

func _on_body_entered(body):
	if body is Cat:
		emit_signal("key_collected")
		queue_free()
	pass
