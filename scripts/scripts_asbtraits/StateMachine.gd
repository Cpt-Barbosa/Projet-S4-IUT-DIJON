extends Node
#ce script joue le rôle d'un interface on va l'attacher au scène qui utiliseront l'automate
#EXEMPLE D'UTILISATION DANS JOUEUR
class_name StateMachine

#etat actuel de l'objet
var state = null setget set_state
#etat précédent de l'objet
var previous_state = null
#dictionnaire qui contient le nom des différents états
var states = {}

#ce que l'automate contrôle et qui contient les méthodes que va appeler l'automate
onready var parent = get_parent()

func _physics_process(delta):
	#si on a un état on effectue son code de logique
	if state != null:
		state_logic(delta)
		var transition = get_transition(delta)
		#si transition est null cela veut dire qu'il ne faut pas changer d'état
		if transition != null:
			set_state(transition)
		
#fonction qui gère ce que fait l'état à chaque tic
#par exemple un état saut change la vélocité en y et appelle move_and_slide
func state_logic(delta):
	pass
	
#fonction qui gère si on peut passer d'un état à un autre 
func get_transition(delta):
	return null

#fonction qui gère les changements lorsqu'on entre dans un nouvel état
#par exemple des animations ou un lancement de timer
#new_state est l'état dans lequel on entre
#old_state l'ancien etat
func enter_state(new_state, old_state):
	pass

#fonction qui gère les changements lorsqu'on quitte un état
func exit_state(old_state,new_state):
	pass
	
#fonction qui change l'état
func set_state(new_state):
	previous_state = state
	state = new_state
	
	#si on avait un état avant on appelle la fonction qui quitte cet état
	if previous_state != null:
		exit_state(previous_state, new_state)
	#si on a bien un nouvel état on appelle la fonction pour rentrer dans cet état
	if new_state != null:
		enter_state(new_state, previous_state)

#fonction pour rajouté un état au dictionnaire des états
#ici quand le dictionnaire est vide la taille est de zéro donc on ajoute à la position zéro
#ensuite à la position une etc...
func add_state(state_name):
	states[state_name] = states.size()
