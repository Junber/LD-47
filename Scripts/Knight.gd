extends "res://Scripts/Enemy.gd"

var shieldRotation = 0
export var shieldedAngle = 180

#this is the angle in radians that the shield rotates per second
export var shieldRotationSpeed = PI / 3

func _ready():
	$ShieldSprite.value = shieldedAngle

func kill():
	if !dead:
		.kill()
		$ShieldSprite.visible = false

func angleToShield(theirPosition):
	return (theirPosition - global_position).angle_to(Vector2(0,-1).rotated(shieldRotation))

func protected(collider):
	#the shielded angled is halved because the shied extends to both sides
	return abs(angleToShield(collider.global_position)) <= shieldedAngle * PI / 180 / 2

func damageDealt():
	return -30

func getDirection():
	return .getDirection() / 2

func _process(delta):
	if !dead:
		var angle = angleToShield($"../Player".global_position)
		if abs(angle) > 0.1:
			shieldRotation += -sign(angle) * shieldRotationSpeed * delta
		$ShieldSprite.rect_rotation = (shieldRotation - rotation) / PI * 180
