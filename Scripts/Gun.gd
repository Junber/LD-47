extends "res://Scripts/Item.gd"

func getHitBy(collider, _collision):
	collider.bulletsLeft = 6
	getUsed()
