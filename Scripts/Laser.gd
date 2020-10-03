extends RayCast2D

onready var laserBeam = $LaserBeam

func _physics_process(delta):
	rotation += delta
	
	if is_colliding():
		var point = get_collision_point()
		laserBeam.points[1]=to_local(point)
		print(get_collider().name)
