extends RayCast2D

onready var laserBeam = $LaserBeam
onready var laserSparks = $Sparks
export var damage = -800

func _process(_delta):
	if get_parent().dead:
		queue_free()

func _physics_process(delta):
	rotation += delta
	
	if is_colliding():
		var laserEndPoint = to_local(get_collision_point())
		laserBeam.points[1] = laserEndPoint
		laserSparks.position = laserEndPoint
	get_collider().collideWithLaser(get_parent(), damage * delta)
	
	var offset = global_position - $"../../Player".global_position
	var normal = (cast_to - position).normalized()
	var dist = (offset - (offset.dot(normal) * normal)).length()
	$LaserSoundPlayer.pitch_scale = dist / 1000


func _on_LaserSoundPlayer_finished():
	$LaserSoundPlayer.play()
