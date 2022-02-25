extends KinematicBody2D

onready var player = get_parent().get_node("Joueur")

var velocity = Vector2.ZERO
var speed = 32

#si le joueur est dans la zone de vision du garde
var in_range=false
#
var see_player=false
#si le garde bouge vers la gauche 
var is_moving_left=true

#compteur pour le nombre de tour que fait le garde
var i = 0
#position minimale du garde en x il change de sens après avoir atteint cette position
export var min_x=0
#même chose mais max
export var max_x=100
#nombre max de tour que fait le garde avant de se stopper
export var max_tour=2
#temps que le garde reste sans bouger (TO-DO)
export var stop_time=2

func apply_movement():
	#si le garde à le nom garde immobilequelquechose il ne bougera jamais
	if !name.match("GardeImmobile*"):
		velocity.x=-speed if is_moving_left else speed
		velocity=move_and_slide(velocity, Vector2.UP)

func is_seeing():
	if !player.hidden && in_range || player.hidden && in_range && player.flashlight.is_enabled():
		see_player=true
	else:
		see_player=false
		
func detect_turn():
	#si le garde à le nom garde immobilequelquechose et ne tournera jamais
	if !name.match("GardeImmobile*"):
		if position.x <=min_x || position.x >=max_x:
			scale.x=-scale.x
			is_moving_left= !is_moving_left
			i+=1

func _on_Sight_body_entered(body):
	if body == player:
		in_range=true

func _on_Sight_body_exited(body):
	if body == player:
		in_range=false
