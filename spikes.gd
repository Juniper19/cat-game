extends Area2D

func _on_body_entered(body):
	if body is Cat:
		get_tree().reload_current_scene() #Respawns player at start
	pass
