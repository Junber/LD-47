extends KinematicBody2D

var velocity = Vector2(0,0)
var rotationSpeed = 0

func _ready():
	rotationSpeed = rand_range(50, 100)

func getHitBy(_collider, _collision):
	pass

func getUsed():
	visible = false
	collision_layer = 0
	collision_mask = 0
	$PickupSoundPlayer.play()

func collideWithWall(_collider, collision):
	velocity = velocity.bounce(collision.normal)

func collideWithPlayer(collider):
	getHitBy(collider, null)

func _process(delta):
	if visible:
		velocity *= pow(0.9, delta)
		velocity -= velocity.normalized() * 100 * delta
		rotationSpeed *= pow(0.8, delta)
		rotationSpeed -= 30 * delta
		if rotationSpeed < 0:
			rotationSpeed = 0
		
		rotation += rotationSpeed * delta
		
		var collision = move_and_collide(velocity * delta)
		if collision:
			collision.collider.getHitBy(self, collision)

#this only allows the potion to be picked up when it almost stopped
#which is a cheap workaround/feature for avoiding it gettng used when spawned
func _on_NoPickUpTimer_timeout():
	set_collision_mask_bit(0, true)


func _on_PickupSoundPlayer_finished():
	queue_free()
	get_parent().itemPickedUp()
