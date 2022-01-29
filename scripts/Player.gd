extends KinematicBody2D

#vitesse du jouer en pixel par secondes
export (int) var speed = 200
#récupère la valeur par défaut de la gravité
export (int) var g = 4500

var velocity = Vector2.ZERO
#-1 si on va à gauche +1 si à droite
var horizontal_direction=0

func _ready():
	pass # Replace with function body.
	
func apply_movement():
	velocity.x=horizontal_direction*speed
	velocity = move_and_slide(velocity,Vector2.UP)
	
func apply_gravity(delta):
	velocity.y += g*delta
	
func handle_move_input():
	horizontal_direction=0
	if Input.is_action_pressed("move_left"):
		horizontal_direction = -1.0
	
	if Input.is_action_pressed("move_right"):
		horizontal_direction = 1.0
	
	
