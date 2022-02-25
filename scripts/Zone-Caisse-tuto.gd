extends ObjetInteractible

func _ready():
	shown_text="Accroupissez-vous Shift"
	
func is_interacted():
	get_tree().change_scene("res://scenes/Zone_2_Entree.tscn")

#si le joueur est dans la zone de l'objet qu'il est accroupi et qu'il appuie sur e ça le change de zone
func get_input():
	if(object_entered):
		#s'il est accroupi on change le texte pour lui dire d'appuyer sur E
		if Input.is_action_pressed("crouch"):
			shown_text="Se faufiller E"
			if(Input.is_action_just_pressed("interact")):
				is_interacted()
		#si non le texte reviens à accroupissez-vous
		else:
			shown_text="Accroupissez-vous Shift"

