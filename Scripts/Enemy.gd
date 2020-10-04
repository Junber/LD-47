extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"

signal enemyDied
signal enemyKilledByPlayer
signal enemyNotKilledByPlayer

func protected(_collider):
	return false

func collideWithIceScater(collider):
	if dead or collider.dead:
		return
		
	var damageToOther = damageDealt()
	if !protected(collider):
		bounceOffOfIceScater(collider)
		changeHealth(collider.damageDealt())
		if dead:
			damageToOther = 0
			emit_signal("enemyKilledByPlayer")
		else:
			emit_signal("enemyNotKilledByPlayer")
	else:
		emit_signal("enemyNotKilledByPlayer")
	collider.bounceOffOfIceScater(self)
	collider.changeHealth(damageToOther)

func checkDrop():
	if randf()<0.5:
		var newDrop = load("res://Scenes/HealingPotion.tscn").instance()
		newDrop.position=self.position
		var DegreesInRadians = 0.34
		var newVelocity = (self.velocity * 0.5).rotated(randf()*DegreesInRadians-(DegreesInRadians/2))
		newDrop.velocity += newVelocity
		get_parent().call_deferred("add_child",newDrop)

func kill():
	if !dead:
		.kill()
		checkDrop()
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(1, false)
		get_node("../HUD/ScoreLabel").increaseScore()
		emit_signal("enemyDied")

func getDirection():
	if !dead and !player.dead:
		return (player.position - position).normalized()
	else:
		return Vector2(0,0)
