extends Area2D

class_name TriggerNiveau
export var niveau  ="Zone_3.tscn"

#quand le jouer touche l'area 2d ça change de niveau
func change_level(body):
	if body.name == "Joueur":
		get_tree().change_scene("res://scenes/"+niveau)
