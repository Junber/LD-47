extends "res://Scripts/Item.gd"

func getHitBy(collider, _collision):
	collider.getShield()
	getUsed()
