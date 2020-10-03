extends "res://Scripts/IceScater.gd"

onready var boostTimer = $BoostCooldownTimer
onready var boostProgressBar = $BoostCooldownProgessBar

func _ready():
	pass

func kill():
	$"../ArenaCamera".make_current()
	queue_free()

func getDirection():	
	var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	return Vector2(x,y)

func _process(delta):
	spinUp(delta)
	
	boostProgressBar.value = boostTimer.time_left / boostTimer.wait_time
	if Input.is_action_just_pressed("boost"):
		if boostTimer.is_stopped():
			boostTimer.start()
			boost()
