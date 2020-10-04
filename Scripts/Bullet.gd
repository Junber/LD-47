extends KinematicBody2D

var velocity
export var damage = -20

func getHitBy(collider, _collision):
	if !is_queued_for_deletion():
		collider.collideWithBullet(self)
		queue_free()
	
func collideWithWall(_collider, _collision):
	queue_free()

func collideWithBullet(collider):
	if !is_queued_for_deletion():
		queue_free()
		collider.queue_free()

func collideWithPlayer(collider):
	getHitBy(collider, null)
	
func collideWithEnemy(collider):
	getHitBy(collider, null)

func collideWithLaser(_collider, _damage):
	queue_free()

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		collision.collider.getHitBy(self, collision)
