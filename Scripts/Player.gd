extends "res://Scripts/IceScater.gd"

signal playerDied

onready var boostTimer = $BoostCooldownTimer
onready var boostProgressBar = $BoostCooldownProgessBar

func kill():
	if !dead:
		.kill()
		$"../ArenaCamera".make_current()
		emit_signal("playerDied")

func getDirection():
	if dead:
		return Vector2(0,0)
	else:
		var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		
		return Vector2(x,y)

func _process(_delta):
	boostProgressBar.value = boostTimer.time_left / boostTimer.wait_time
	if Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start()
			boost()
