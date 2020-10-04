extends KinematicBody2D

onready var healthBar = $HealthBar
onready var deadSprite = $DeadSprite
onready var aliveSprite = $AliveSprite
onready var particleEmitter = $BloodParticles
export var acceleration = 1000

export var health = 160

const maxRotationSpeed = 600

export var rotationIncrease = 50

var timeMultiplier = 1

var velocity = Vector2(0,0)
var rotationSpeed = 1
var dead = false

func _ready():
	healthBar.max_value = health
	healthBar.value = health
	
func protected(_collider):
	return false

func collideWithWall(_collider, collision):
	velocity = velocity.bounce(collision.normal) / 2
	rotationSpeed /= 2

func collideWithLaser(collider, damage):
	if !protected(collider):
		changeHealth(damage)

func collideWithBullet(collider):
	if !protected(collider):
		changeHealth(collider.damage)
	
func collideWithIceScater(_collider):
	pass

func bounceOffOfIceScater(collider, velocityLength):
	velocity = (position - collider.position).normalized() * velocityLength
	rotationSpeed /= 2

func getDirection():
	return Vector2(0,0)

func damageDealt():
	return max(-(rotationSpeed + velocity.length() / 2) * 0.1, -80)

func kill():
	if !dead:
		deadSprite.visible = true
		aliveSprite.visible = false
		particleEmitter.emitting = true
		dead = true

func changeHealth(amount):
	healthBar.value += amount
	healthBar.value = clamp(healthBar.value, 0, healthBar.max_value)
	if healthBar.value <= 0:
		kill()

func spinUp(delta):
	rotationSpeed = min(rotationSpeed + rotationIncrease * delta, maxRotationSpeed)

func setSpriteRotation(rotation):
	deadSprite.rotate(rotation)
	aliveSprite.rotate(rotation)

func _process(delta):
	delta *= timeMultiplier
	velocity += getDirection() * acceleration * delta
	velocity *= pow(0.9, delta)
	velocity -= velocity.normalized() * 100 * delta
	
	if dead:
		rotationSpeed *= pow(0.6, delta)
	else:
		spinUp(delta)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		collision.collider.getHitBy(self, collision)
	
	setSpriteRotation(0.1 * delta * rotationSpeed)
