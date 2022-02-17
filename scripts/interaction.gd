extends ObjetInteractible

var has_push = false
var trou = "scenes/Zone-Caisse-tuto.tscn"

func _process(delta):
	if(has_push):
		self.object_entered = false


func is_interacted():
	if(!has_push):
		has_push = true
		var posx = self.position.x
		var posy = self.position.y
		if(get_parent().get_node("Joueur").position.x < position.x):
			get_node("déplacement").play("déplacement")
		else:
			get_node("déplacement").play("déplacement_inverse")
		var res = load(trou)
		var trou = res.instance()
		trou.transform = Transform2D(0,Vector2(posx,posy))
		get_tree().get_root().add_child(trou)
		
		



