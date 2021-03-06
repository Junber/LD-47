extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"

signal enemyDied(enemy)
signal enemyKilledByPlayer
signal enemyNotKilledByPlayer

var typeIndex

export (PackedScene) var itemScene

func getHitBy(collider, _collision):
	collider.collideWithEnemy(self)

func playSfx(collider):
	if protected(collider) or collider.protected(self):
		$ShieldSoundPlayer.play()
	if dead or collider.dead:
		$KillSoundPlayer.play()
	else:
		$DamageSoundPlayer.play()

func collideWithPlayer(collider):
	if dead or collider.dead:
		return
		
	var damageToOther = damageDealt()
	var velocityLength = (velocity.length() + collider.velocity.length()) / 2
	
	bounceOffOfIceScater(collider, velocityLength)
	if !protected(collider):
		var damageToSelf = collider.damageDealt()
		changeHealth(damageToSelf)
		if dead:
			damageToOther = 0
			emit_signal("enemyKilledByPlayer")
		elif damageToSelf < -60:
			damageToOther = 0
		else:
			emit_signal("enemyNotKilledByPlayer")
	else:
		emit_signal("enemyNotKilledByPlayer")
	
	collider.bounceOffOfIceScater(self, velocityLength)
	if !collider.protected(self):
		collider.changeHealth(damageToOther)
	
	playSfx(collider)

func collideWithEnemy(collider):
	if dead or collider.dead:
		return
		
	var damageToOther = damageDealt()
	var velocityLength = (velocity.length() + collider.velocity.length()) / 2
	
	bounceOffOfIceScater(collider, velocityLength)
	if !protected(collider):
		changeHealth(collider.damageDealt())
		
	collider.bounceOffOfIceScater(self, velocityLength)
	if !collider.protected(self):
		collider.changeHealth(damageToOther)
	
	playSfx(collider)

func checkDrop():
	if randf() <= get_parent().itemDropRate:
		var newDrop = itemScene.instance()
		newDrop.position = self.position
		var DegreesInRadians = 0.34
		var newVelocity = (self.velocity * 0.3).rotated(randf()*DegreesInRadians-(DegreesInRadians/2))
		newDrop.velocity = newVelocity
		get_parent().call_deferred("add_child",newDrop)

func kill():
	if !dead:
		checkDrop()
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, false)
		set_collision_layer_bit(1, false)
		remove_from_group("enemies")
		z_index -= 1
		emit_signal("enemyDied", self)
		.kill()

func getDirection():
	if !dead and !player.dead:
		return (player.position - position).normalized()
	else:
		return Vector2(0,0)
