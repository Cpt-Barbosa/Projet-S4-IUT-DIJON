extends ObjetInteractible


func is_interacted():
	get_parent().get_node("Porte").queue_free()
	queue_free()

