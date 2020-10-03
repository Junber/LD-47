extends RayCast2D

onready var laserBeam = $LaserBeam
export var damage = 10;

func getHitBy(collider, collision):
	pass

func collideWithWall(collider, collision):
	pass
	
func collideWithIceScater(collider):
	collider.takeDamage(damage)

func _physics_process(delta):
	rotation += delta
	
	if is_colliding():
		var point = get_collision_point()
		laserBeam.points[1]=to_local(point)
		get_collider().getHitBy(self, null)

