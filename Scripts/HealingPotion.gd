extends "res://Scripts/Item.gd"

export var healingAmount = 50

func getHitBy(collider, _collision):
	collider.changeHealth(healingAmount)
	getUsed()

func collideWithWall(_collider, collision):
	velocity = velocity.bounce(collision.normal) / 2
