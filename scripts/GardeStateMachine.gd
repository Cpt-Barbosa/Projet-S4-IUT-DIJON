extends StateMachine

var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("walking")
	add_state("spotting")
	call_deferred("set_state",states.walking)

#fonction qui gère ce que fait l'état à chaque tic
#par exemple un état saut change la vélocité en y et appelle move_and_slide
func state_logic(delta):
	#ici parent est le garde
	#si le garde est entrain de marcher ou ne bouge pas il regarde s'il voit le joueur
	if[states.idle, states.walking,states.spotting].has(state):
		parent.is_seeing()
	if[states.walking].has(state):
		parent.detect_turn()
		parent.apply_movement()

func get_transition(delta):
	match state:
		states.idle:
			if parent.see_player:
				return states.spotting
		states.walking:
			if parent.see_player:
				return states.spotting
			elif parent.i>parent.max_tour:
				parent.i=0
				return states.idle
		states.spotting:
			if !parent.see_player:
				return states.walking
			
func enter_state(new_state, old_state):
	match new_state:
		states.idle:
			timer = Timer.new()
			timer.connect("timeout",self,"after_idle") 
			#timeout is what says in docs, in signals
			#self is who respond to the callback
			#_on_timer_timeout is the callback, can have any name
			add_child(timer) #to process
			timer.start(parent.stop_time) #to start
		states.walking:
			print("guard walking")
		states.spotting:
			print("guard spotting")
			timer = Timer.new()
			timer.connect("timeout",self,"spotting_player") 
			#timeout is what says in docs, in signals
			#self is who respond to the callback
			#_on_timer_timeout is the callback, can have any name
			add_child(timer) #to process
			timer.start() #to start

func spotting_player():
	timer.stop()
	if parent.see_player:
		print("Vous avez été arrêté")
		get_tree().change_scene("res://scenes/Zone_1_Dehors.tscn")

func after_idle():
	timer.stop()
	set_state(states.walking)
