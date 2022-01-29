extends StateMachine


# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("walking")
	add_state("crouching")
	add_state("crawling")
	add_state("interacting")
	#appelle la méthode set_state sur le premier état après que le parent est fini de charger
	call_deferred("set_state",states.idle)
	
#fonction qui gère ce que fait l'état à chaque tic
#par exemple un état saut change la vélocité en y et appelle move_and_slide
func state_logic(delta):
	#ici parent est le joueur
	parent.handle_move_input()
	parent.apply_gravity(delta)
	parent.apply_movement()
	
#fonction qui gère si on peut passer d'un état à un autre 
func get_transition(delta):
	match state:
		states.idle:
			if parent.velocity.x !=0:
				return states.walking
		states.walking:
			if parent.velocity.x ==0:
				return states.idle
	return null

#fonction qui gère les changements lorsqu'on entre dans un nouvel état
#par exemple des animations ou un lancement de timer
#new_state est l'état dans lequel on entre
#old_state l'ancien etat
func enter_state(new_state, old_state):
	match new_state:
		states.idle:
			#plus tard on aura ici les animations du persos
			print("idle")
		states.walking:
			print("walking")

#fonction qui gère les changements lorsqu'on quitte un état
func exit_state(old_state,new_state):
	pass
