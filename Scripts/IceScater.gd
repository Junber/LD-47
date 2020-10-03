extends KinematicBody2D

onready var healthBar = $HealthBar
export var acceleration = 1000

const maxRotationSpeed = 1000

var velocity = Vector2(0,0)
var rotationSpeed = 1

func _ready():
	pass

func collideWithWall(collider, collision):
	velocity = velocity.bounce(collision.normal) / 2
	rotationSpeed /= 2
	
func collideWithIceScater(collider):
	velocity = (position - collider.position).normalized() * velocity.length() / 2

func getHitBy(collider, collision):
	collider.collideWithIceScater(self)

func getDirection():
	return Vector2(0,0)

func boost():
	velocity = getDirection() * max(velocity.length() * 1.5, 3000)
	rotationSpeed = min(rotationSpeed + 100, maxRotationSpeed)

func damageDealt():
	return (rotationSpeed + velocity.length() / 2) * 0.1

func kill():
	queue_free()

func takeDamage(amount):
	healthBar.value -= amount
	if healthBar.value <= 0:
		kill()
		return true
	return false

func hitIceScater(_collision):
	pass

func spinUp(delta):
	rotationSpeed = min(rotationSpeed + 10 * delta, maxRotationSpeed)

func setSpriteRotation(_rotation):
	pass

func _process(delta):
	velocity += getDirection() * acceleration * delta
	velocity *= pow(0.9, delta)
	velocity -= velocity.normalized() * 100 * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		collision.collider.getHitBy(self, collision)
	
	setSpriteRotation(0.1 * delta * rotationSpeed)
