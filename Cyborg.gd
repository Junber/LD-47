extends "res://Scripts/Enemy.gd"

var target

func _ready():
	target = $"../Player".position

func collideWithLaser(_damage):
	pass
	
func getDirection():
	if !dead:
		if (target - position).length() > 100:
			return (target - position).normalized()
		else:
			return -velocity.normalized()
	else:
		return Vector2(0,0)
