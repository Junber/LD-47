extends KinematicBody2D

onready var sprite = $Sprite
export var acceleration = 1000
export var rotationSpeed = 100

var velocity = Vector2(0,0)

func _ready():
	pass

func getDirection():
	return Vector2(0,0)

func _process(delta):
	velocity += getDirection() * acceleration * delta
	velocity *= pow(0.9, delta)
	velocity -= velocity.normalized() * 100 * delta
		
	if move_and_collide(velocity * delta):
		velocity = Vector2(0,0)
		
	sprite.rotate(0.1 * delta * rotationSpeed)
