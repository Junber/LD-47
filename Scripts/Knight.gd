extends "res://Scripts/Enemy.gd"

var shieldRotation = 0
export var shieldedAngle = 180

func kill():
	if !dead:
		.kill()
		$ShieldSprite.visible = false

func protected(collider):
	#the shielded angled is halved because the shied extends to both sides
	return abs((collider.global_position - global_position).angle_to(Vector2(0,-1).rotated(shieldRotation))) <= shieldedAngle * PI / 180 / 2

func getDirection():
	return .getDirection() / 2

func _process(delta):
	if !dead:
		var angle = ($"../Player".global_position - global_position).angle_to(Vector2(0,-1).rotated(shieldRotation))
		
		if abs(angle) > 0.1:
			shieldRotation += -sign(angle) * delta
		$ShieldSprite.rotation = shieldRotation - rotation
