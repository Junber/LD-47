extends KinematicBody2D

onready var sprite = $Sprite
onready var healthBar = $HealthBar
export var acceleration = 1000

const maxRotationSpeed = 1000

var velocity = Vector2(0,0)
var rotationSpeed = 1

func _ready():
	pass

func getDirection():
	return Vector2(0,0)

func boost():
	velocity = getDirection() * max(velocity.length() * 1.5, 3000)
	rotationSpeed = min(rotationSpeed + 100, maxRotationSpeed)

func damageDealt():
	return (rotationSpeed + velocity.length() / 2) * 0.1

func getHit(other, damage):
	velocity = (position - other.position).normalized() * velocity.length() / 2
	rotationSpeed = 1
	healthBar.value -= damage
	if healthBar.value <= 0:
		queue_free()

func hitWall(normal):
	velocity = velocity.bounce(normal) / 2
	rotationSpeed = 1

func _process(delta):
	velocity += getDirection() * acceleration * delta
	velocity *= pow(0.9, delta)
	velocity -= velocity.normalized() * 100 * delta
	
	rotationSpeed = min(rotationSpeed + 10 * delta, maxRotationSpeed)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("getHit"):
			var previousDamage = damageDealt()
			getHit(collision.collider, collision.collider.damageDealt())
			collision.collider.getHit(self, previousDamage)
		else:
			hitWall(collision.normal)
		
	
	sprite.rotate(0.1 * delta * rotationSpeed)
