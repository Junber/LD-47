extends "res://Scripts/IceScater.gd"

func _ready():
	pass

func getDirection():
	var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	return Vector2(x,y)
