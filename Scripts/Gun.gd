extends "res://Scripts/Item.gd"

func getHitBy(collider, _collision):
	collider.setBulletsLeft(4)
	getUsed()
