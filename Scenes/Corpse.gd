extends "res://Scripts/IceScater.gd"

onready var particleEmitter = $Particles2D

func _ready():
	particleEmitter.emitting = true

func _process(delta):
	rotationSpeed *= pow(0.6, delta)
