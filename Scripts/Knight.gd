extends "res://Scripts/Enemy.gd"

func protected(collider):
	return abs((global_position - collider.global_position).angle_to(Vector2(0,1))) <= PI / 2

func _process(_delta):
	rotationSpeed = 0
