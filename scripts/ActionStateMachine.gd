extends StateMachine

onready var sprite = parent.get_node("Sprite")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("none")
	add_state("hidden")
	call_deferred("set_state",states.none)

func get_transition(delta):
	match state:
		states.none:
			if Input.is_action_pressed("crouch") && parent.can_hide:
				return states.hidden
		states.hidden:
			if !Input.is_action_pressed("crouch") || !parent.can_hide:
				return states.none
			
func enter_state(new_state, old_state):
	match new_state:
		states.none:
			#change la couleur pour la remettre par défaut et décache le joueur
			sprite.modulate = Color(1,1,1)
			parent.hidden=false
		states.hidden:
			#change la coloration du sprite pour qu'il soit moins visible (indication pour le joueur qu'il est caché)
			#si le joueur est caché (dans un buisson)
			sprite.modulate = Color(0.2,0.2,0.2)
			parent.hidden=true
			
