extends Area2D
#classe abstraite qui défini un objet interractible par le joueur
#VOIR OBJET TEST POUR UN EXEMPLE
class_name ObjetInteractible

#variable a utilisé pour voir si le joueur peut intéragir avec l'objet ou pas 
var object_entered = false
onready var text = get_node("Texte")
#il faudra redéfinir la fonction process dans le script qui hérite de celui et mettre get_input() pour récupérer l'input du joueur
func _process(delta):
	get_input()
	if(object_entered):
		text.text="E"
	else:
		text.clear()

#si le joueur rentre dans la zone de collision de l'objet interactible on passe le booléan à true
func _on_body_entered(body):
	if(body.name=="Joueur"):
		object_entered = true

#si le jouer sort de la zone d'interaction on le passe à false
func _on_body_exited(body):
	if(body.name=="Joueur"):
		object_entered = false

#si le joueur est dans la zone d'interaction et qu'il appuie sur un des boutons d'interactions lance la fonction d'interaction
func get_input():
	if(object_entered):
		if(Input.is_action_just_pressed("interact")):
			is_interacted()

func is_interacted():
	pass
