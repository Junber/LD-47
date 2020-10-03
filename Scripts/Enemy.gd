extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"

signal enemyDied
signal enemyDidNotDie

func protected(_collider):
	return false

func collideWithIceScater(collider):
	if dead or collider.dead:
		return
		
	var damageToOther = damageDealt()
	if !protected(collider):
		bounceOffOfIceScater(collider)
		takeDamage(collider.damageDealt())
		if dead:
			damageToOther = 0
			emit_signal("enemyDied")
		else:
			emit_signal("enemyDidNotDie")
	else:
		emit_signal("enemyDidNotDie")
	collider.bounceOffOfIceScater(self)
	collider.takeDamage(damageToOther)

func kill():
	if !dead:
		.kill()
		set_collision_mask_bit(0, false)		
		get_node("../HUD/ScoreLabel").increaseScore()

func getDirection():
	if !dead and !player.dead:
		return (player.position - position).normalized()
	else:
		return Vector2(0,0)
