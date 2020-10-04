extends "res://Scripts/IceScater.gd"

signal playerDied

onready var boostTimer = $BoostCooldownTimer
onready var boostProgressBar = $BoostCooldownProgessBar

func kill():
	if !dead:
		.kill()
		$"../ArenaCamera".make_current()
		emit_signal("playerDied")

func collideWithHealingPotion(collider):
	self.changeHealth(collider.healingAmount)	
	collider.getUsed()

func getDirection():
	if dead:
		return Vector2(0,0)
	else:
		var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		
		return Vector2(x,y)

func _process(delta):
	boostProgressBar.value = boostTimer.time_left / boostTimer.wait_time
	if Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start()
			boost()
	
	var zoomSpeed = 1.0
	var newZoom = min(max(velocity.length(), 500) / 1000, 2)
	var zoomDifference = newZoom - $PlayerCamera.zoom.x
	if abs(zoomDifference) > zoomSpeed*delta:
		$PlayerCamera.zoom = $PlayerCamera.zoom + zoomSpeed*delta * sign(zoomDifference) * Vector2(1,1)
	else:
		$PlayerCamera.zoom = Vector2(newZoom,newZoom)
