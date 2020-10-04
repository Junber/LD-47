extends KinematicBody2D

export var healingAmount = 50

var velocity = Vector2(0,0)

func getHitBy(collider, _collision):
	collider.collideWithHealingPotion(self)

func getUsed():
	queue_free()

func collideWithWall(_collider, collision):
	velocity = velocity.bounce(collision.normal) / 2

func _process(delta):
	velocity *= pow(0.9, delta)
	velocity -= velocity.normalized() * 100 * delta
	#warning-ignore:return_value_discarded
	move_and_collide(velocity * delta)

#this only allows the potion to be picked up when it almost stopped
#which is a cheap workaround/feature for avoiding it gettng used when spawned
func _on_NoPickUpTimer_timeout():
	set_collision_mask_bit(0, true)
