extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"

func _ready():
	pass

func getDirection():
	if player:
		return (player.position - position).normalized()
	else:
		return Vector2(0,0)
