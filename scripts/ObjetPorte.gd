extends ObjetInteractible

func _ready():
	shown_text="Ouvrir la porte E"
	get_parent().get_node("PorteOuverte").hide()
	
func is_interacted():
	get_parent().get_node("Porte").queue_free()
	get_parent().get_node("PorteOuverte").show()
	queue_free()

