extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"

signal enemyDied
signal enemyDidNotDie

func _ready():
	pass

func collideWithIceScater(collider):
	bounceOffOfIceScater(collider)
	var damageToOther = damageDealt()
	if takeDamage(collider.damageDealt()):
		damageToOther = 0
		emit_signal("enemyDied")
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
