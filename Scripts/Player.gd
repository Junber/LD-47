extends "res://Scripts/IceScater.gd"

signal playerDied

onready var boostTimer = $BoostCooldownTimer
onready var boostProgressBar = $BoostCooldownProgessBar

var hasShield = false
export var shieldDuration = 5.0
export var slowDownDuration = 5.0

var bulletScene = load("res://Scenes/Bullet.tscn")
var bulletsLeft = 0

func getShield():
	hasShield = true;
	$Shield.visible = true
	yield(get_tree().create_timer(shieldDuration), "timeout")
	hasShield = false;
	$Shield.visible = false
	
func protected(_collider):
	return hasShield
	
func slowTime():
	if $SlowdownTimer.is_stopped():
		timeMultiplier = 5
		Engine.time_scale /= timeMultiplier
		
		var audioEffect = AudioEffectPitchShift.new()
		audioEffect.pitch_scale = 0.5
		AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), audioEffect, 0)
		$SlowdownTimer.start(slowDownDuration / timeMultiplier)
	else:
		$SlowdownTimer.start($SlowdownTimer.time_left + slowDownDuration / timeMultiplier)

func _on_SlowdownTimer_timeout():
	AudioServer.remove_bus_effect(AudioServer.get_bus_index("Master"),  0)
	
	Engine.time_scale *= timeMultiplier
	timeMultiplier = 1

var bulletsLeft = 0
func changeHealth(amount):
	if amount < 0:
		$"PlayerCamera/Screenshaker".start()
	.changeHealth(amount)

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

func getSpecialDirection():
	var direction = getDirection()
	if direction.length() == 0:
		if velocity.length() == 0:
			return Vector2(1,0)
		else:
			return velocity.normalized()
	else:
		return direction
	
func boost():
	velocity = getSpecialDirection() * max(velocity.length() * 1.5, 3000)
	rotationSpeed = min(rotationSpeed + 100, maxRotationSpeed)

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = position
	bullet.velocity = getSpecialDirection() * max(2 * velocity.length(), 5000)
	bullet.position += bullet.velocity.normalized() * 100
	bullet.damage = -200
	get_parent().add_child(bullet)
	$GunShotPlayer.play()
	bulletsLeft -= 1

func _process(delta):
	delta *= timeMultiplier
	
	boostProgressBar.value = boostTimer.time_left / boostTimer.wait_time
	if !dead and Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start()
			if bulletsLeft > 0:
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
