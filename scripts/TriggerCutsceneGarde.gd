extends Area2D

var timer
onready var garde =get_parent().get_parent().get_node("GardeImmobile")

func start_cutscene(body):
	if body.name=="Joueur":
		timer = Timer.new()
		timer.connect("timeout",self,"move_guard") 
		#timeout is what says in docs, in signals
		#self is who respond to the callback
		#_on_timer_timeout is the callback, can have any name
		add_child(timer) #to process
		timer.start(3) #to start# Replace with function body.
		
		

func move_guard():
	timer.stop()
	get_parent().get_parent().get_node("CutscenePlayer").play("cutscene")
	get_tree().get_root().set_disable_input(true)
	queue_free()
