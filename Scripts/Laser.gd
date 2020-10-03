extends RayCast2D

onready var laserBeam = $LaserBeam
onready var laserSparks = $Sparks
export var damage = 10;

func getHitBy(_collider, _collision):
	pass

func collideWithWall(_collider, _collision):
	pass
	
func collideWithIceScater(collider):
	collider.takeDamage(damage)

func _process(_delta):
	if get_parent().dead:
		queue_free()

func _physics_process(delta):
	rotation += delta
	
	if is_colliding():
		var point = to_local(get_collision_point())
		laserBeam.points[1]=point
		laserSparks.position=point
		get_collider().getHitBy(self, null)

