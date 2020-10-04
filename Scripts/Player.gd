extends "res://Scripts/IceScater.gd"

signal playerDied

onready var boostTimer = $BoostCooldownTimer
onready var boostProgressBar = $BoostCooldownProgessBar

var bulletScene = load("res://Scenes/Bullet.tscn")

var hasGun = false

func kill():
	if !dead:
		.kill()
		$"../ArenaCamera".make_current()
		emit_signal("playerDied")

func getHitBy(collider, _collision):
	collider.collideWithPlayer(self)

func collideWithEnemy(collider):
	collider.collideWithPlayer(self)

func getDirection():
	if dead:
		return Vector2(0,0)
	else:
		if Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(2):
			return position.direction_to(get_global_mouse_position())
		else:
			var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
			var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
			return Vector2(x,y).normalized()

func enemyDied():
	$PlayerCamera.zoom = $PlayerCamera.zoom * 0.6
	#$PlayerCamera.startScreenshake()
	
func boost():
	velocity = getDirection() * max(velocity.length() * 1.5, 3000)
	rotationSpeed = min(rotationSpeed + 100, maxRotationSpeed)

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = position
	var direction = getDirection()
	if direction.length() == 0:
		if velocity.length() == 0:
			bullet.velocity = Vector2(1,0) * 5000
		else:
			bullet.velocity = velocity.normalized() * max(2 * velocity.length(), 5000)
	else:
		bullet.velocity = direction * max(2 * velocity.length(), 5000)
	bullet.position += bullet.velocity.normalized() * 100
	bullet.damage = -200
	get_parent().add_child(bullet)
	$GunShotPlayer.play()

func _process(delta):
	boostProgressBar.value = boostTimer.time_left / boostTimer.wait_time
	if !dead and Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start()
			if hasGun:
				shoot()
			else:
				boost()
	
	var zoomSpeed = 1.0
	var newZoom = min(max(velocity.length(), 1000) / 1000, 2)
	var zoomDifference = newZoom - $PlayerCamera.zoom.x
	if abs(zoomDifference) > zoomSpeed*delta:
		$PlayerCamera.zoom = $PlayerCamera.zoom + zoomSpeed*delta * sign(zoomDifference) * Vector2(1,1)
	else:
		$PlayerCamera.zoom = Vector2(newZoom,newZoom)
