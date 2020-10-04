extends RayCast2D

onready var laserBeam = $LaserBeam
onready var laserSparks = $Sparks
export var damage = -800

var damaging = false

func _process(_delta):
	if get_parent().dead:
		queue_free()

func _physics_process(delta):
	rotation += delta
	
	if is_colliding():
		var laserEndPoint = to_local(get_collision_point())
		laserBeam.points[1] = laserEndPoint
		laserSparks.position = laserEndPoint
		if damaging:
			get_collider().collideWithLaser(get_parent(), damage * delta)

func _on_StartupTimer_timeout():
	damaging = true
	$LaserBeam.default_color = Color("ffffff")
	$Sparks.emitting = true
