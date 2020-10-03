extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"

func _ready():
	pass

func getDirection():
	return (player.position - position).normalized()
