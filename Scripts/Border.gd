extends StaticBody2D

func getHitBy(collider, collision):
	collider.collideWithWall(self, collision)

func collideWithLaser(_collider, _damage):
	pass
