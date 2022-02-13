extends ObjetInteractible

var has_push = false

func is_interacted():
	print("push")
	if(!has_push):
		has_push = true
		get_parent().get_node("déplacement").play("déplacement")



