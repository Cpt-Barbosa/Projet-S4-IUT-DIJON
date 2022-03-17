extends StateMachine

onready var affEtat = parent.get_node("AffEtat")
onready var sprite = parent.get_node("Sprite")
onready var animation_player= parent.get_node("AnimationPlayer")
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
	
	parent.get_input()
	parent.apply_gravity(delta)
	if[states.idle, states.walking].has(state):
		parent.apply_movement(parent.run_speed)
	elif[states.crouching, states.crawling].has(state):
		parent.apply_movement(parent.crawl_speed)
	
	
#fonction qui gère si on peut passer d'un état à un autre 
func get_transition(delta):
	match state:
		states.idle:
			#valeur à modifier si jamais on modifie la vitesse
			if abs(parent.velocity.x) >=0.1:
				return states.walking
			elif Input.is_action_just_pressed("interact"):
				return states.interacting
			elif Input.is_action_pressed("crouch"):
				return states.crouching
		states.walking:
			#valeur à modfifier si jamais on modifier la vitesse
			if abs(parent.velocity.x) <=0.1:
				return states.idle
			elif Input.is_action_just_pressed("interact"):
				return states.interacting
			elif Input.is_action_pressed("crouch"):
				return states.crawling
		states.interacting:
			if parent.velocity.x ==0:
				 return states.idle
			elif parent.velocity.x!= 0:
				return states.walking
		states.crouching:
			if !Input.is_action_pressed("crouch") && parent.can_stand():
				return states.idle
			elif abs(parent.velocity.x) >=0.1:
				return states.crawling
		states.crawling:
			if !Input.is_action_pressed("crouch") && parent.can_stand():
				return states.walking
			elif abs(parent.velocity.x) <=0.1:
				return states.crouching
	return null

#fonction qui gère les changements lorsqu'on entre dans un nouvel état
#par exemple des animations ou un lancement de timer
#new_state est l'état dans lequel on entre
#old_state l'ancien etat
func enter_state(new_state, old_state):
	match new_state:
		states.idle:
			#plus tard on aura ici les animations du persos
			affEtat.text="IDLE"
			animation_player.play("Idle")
		states.walking:
			affEtat.text="WALKING"
			animation_player.play("Marcher")
		states.interacting:
			affEtat.text="INTERACTING"
			
		states.crouching:
			affEtat.text="CROUCHING"
			animation_player.play("Se baisser")
			if(old_state != states.crawling):
				parent.on_crouch()
			
		states.crawling:
			affEtat.text="CRAWLING"
			animation_player.play("Ramper")
			if(old_state != states.crouching):
				parent.on_crouch()
			

#fonction qui gère les changements lorsqu'on quitte un état
func exit_state(old_state,new_state):
	match old_state:
		states.crouching:
			if (new_state != states.crawling) :
				parent.on_stand()
		states.crawling:
			if (new_state != states.crouching) :
				parent.on_stand()
