extends "res://Scripts/IceScater.gd"

signal playerDied
signal boosted
signal shot

onready var boostTimer = $BoostCooldownTimer

var hasShield = false
export var shieldDuration = 5.0
export var slowDownDuration = 5.0
export var boostCooldownDuration = 1.0
export var controllerDeadZone = 0.5

var bulletScene = load("res://Scenes/Bullet.tscn")
var bulletsLeft = 0
var frozen = false

func _ready():
	$PlayerCamera.align()
	$PlayerCamera.make_current()

func getShield():
	hasShield = true
	$Shield.visible = true
	$ShieldTimer.start(shieldDuration)	
	
func protected(_collider):
	return hasShield
	
func slowTime():
	if $SlowdownTimer.is_stopped():
		timeMultiplier = 5
		Engine.time_scale /= timeMultiplier
		if !boostTimer.is_stopped():
			boostTimer.start(boostTimer.time_left / timeMultiplier)
		
		var audioEffect = AudioEffectPitchShift.new()
		audioEffect.pitch_scale = 0.5
		AudioServer.add_bus_effect(AudioServer.get_bus_index("Master"), audioEffect, 0)
		$SlowdownTimer.start(slowDownDuration / timeMultiplier)
	else:
		$SlowdownTimer.start(slowDownDuration / timeMultiplier)

func _on_SlowdownTimer_timeout():
	AudioServer.remove_bus_effect(AudioServer.get_bus_index("Master"),  0)
	
	if !boostTimer.is_stopped():
		boostTimer.start(boostTimer.time_left * timeMultiplier)
	Engine.time_scale *= timeMultiplier
	timeMultiplier = 1

func changeHealth(amount):
	if amount < 0:
		$"PlayerCamera/Screenshaker".start()
	.changeHealth(amount)

func kill():
	if !dead:
		$"../ArenaCamera".make_current()
		$"../HUD/RestartButton".visible = true
		emit_signal("playerDied")
		.kill()

func getHitBy(collider, _collision):
	collider.collideWithPlayer(self)

func collideWithEnemy(collider):
	collider.collideWithPlayer(self)	

func getDirection():
	if dead or frozen:
		return Vector2(0,0)
	else:
		var controllerDirection = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
		if Input.is_mouse_button_pressed(1) or Input.is_mouse_button_pressed(2):
			return position.direction_to(get_global_mouse_position())
		elif controllerDirection.length() >= controllerDeadZone:
			if controllerDirection.length() >= 0.99:
				return controllerDirection.normalized()
			else:
				return controllerDirection
		else:
			var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
			var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
			return Vector2(x,y).normalized()

func enemyDied():
	$PlayerCamera.zoom = $PlayerCamera.zoom * 0.6

func getSpecialDirection():
	var direction = getDirection()
	var controllerDirection = Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3))
	if controllerDirection.length() >= controllerDeadZone:
		return controllerDirection.normalized()
	elif direction.length() == 0:
		if velocity.length() == 0:
			return Vector2(1,0)
		else:
			return velocity.normalized()
	else:
		return direction
	
func boost():
	velocity = getSpecialDirection() * max(velocity.length() * 1.5, 3000)
	rotationSpeed = min(rotationSpeed + 100, maxRotationSpeed)
	emit_signal("boosted")
	
func setBulletsLeft(amount):
	bulletsLeft = amount
	$"../HUD/BulletsLeftLabel".text = str(bulletsLeft)
	$"../HUD/BulletsLeftLabel".visible = bulletsLeft > 0
	$"../HUD/BulletsLeftIcon".visible = bulletsLeft > 0

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = position
	bullet.velocity = getSpecialDirection() * max(2 * velocity.length(), 5000)
	bullet.position += bullet.velocity.normalized() * 100
	bullet.damage = -200
	get_parent().add_child(bullet)
	$GunShotPlayer.play()
	setBulletsLeft(bulletsLeft - 1)
	emit_signal("shot")

func _process(delta):
	delta *= timeMultiplier
	
	if !dead and !frozen and Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start(boostCooldownDuration / timeMultiplier)
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

func _on_ShieldTimer_timeout():
	hasShield = false
	$Shield.visible = false
