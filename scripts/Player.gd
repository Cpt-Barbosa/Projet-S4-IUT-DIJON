extends KinematicBody2D

#vitesse de déplacement du jouer en pixel par secondes
export (int) var run_speed = 200
#vitesse de rampage
export (int) var crawl_speed = 100
#récupère la valeur par défaut de la gravité
export (int) var g = 4500

var velocity = Vector2.ZERO
#-1 si on va à gauche +1 si à droite
var horizontal_direction=0

onready var standing_collision = $HitboxDebout
onready var crouching_collision = $HitboxAccr

func _ready():
	pass # Replace with function body.
	
func apply_movement(var speed):
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
		
	
#fonction a appeler quand le joueur VA s'accroupir	
func on_crouch():
	#à supprimer plus tard c'est pour avoir une idée visuelle
	var sprite = get_node("Sprite")
	sprite.scale = Vector2(1,0.5)
	sprite.offset = Vector2(0,32)
	
	standing_collision.disabled=true
	crouching_collision.disabled=false

#quand le joueur VA se lever
func on_stand():
	#à supprimer plus tard c'est pour avoir une idée visuelle
	var sprite = get_node("Sprite")
	sprite.scale = Vector2(1,1)
	sprite.offset = Vector2(0,0)
	
	standing_collision.disabled=false
	crouching_collision.disabled=true
	
#fonction qui regarde si on peut se mettre debout utiliser dans la state machine du joueur avant de passer de crouch/crawl à idle/walking
func can_stand() -> bool:
	#on récupère l'état de l'espace 2D
	var space_state = get_world_2d().direct_space_state
	#on créer un objet query qui sert à simuler une collision
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(standing_collision.shape)
	query.transform = standing_collision.global_transform
	query.collision_layer = collision_mask
	#la variable résulats contient tout les objets avec lequel il y a eu une collision
	var results = space_state.intersect_shape(query)
	#on itère dans cet array à l'envers on commence par le dernier et on remonte
	for i in range(results.size()-1, -1, -1):
		
		var collider = results[i].collider
		var shape = results[i].shape
		#si le collisionneur l'objet qui a collisionné avec le joueur est une tile map
		if collider is TileMap:
			#on récupère les coordonnées de la cellule
			var tile_id = collider.get_cellv(results[i].metadata)
			#si cette cellule est une "one way collision", on peut passer au travers
			if collider.tile_set.tile_get_shape_one_way(tile_id, 0):
				#donc on l'enlève
				results.remove(i)
		#lorsqu'on change laquelle des hitbox est désactivé j'ai l'impression qu'une collision s'effectue entre les deux
		#donc si jamais on collision avec kinematicbody2d qui a pour nom joueur on l'enlève
		if collider is KinematicBody2D:
			if collider.name == "Joueur":
				results.remove(i)
	#si les résultats sont vides le joueur ne collisionnerais avec rien si il se levait donc on renvoie true
	#sinon si la liste n'est pas vide cela veut dire que l'on collisionnerait avec quelque chose donc on ne peut pas se lever
	return results.size()==0
