extends "res://Scripts/Item.gd"

func getHitBy(collider, _collision):
	collider.getShield()
	getUsed()

func _ready():
	pass # Replace with function body.
