extends "res://Scripts/IceScater.gd"

onready var player = $"../Player"
onready var deadSprite = $DeadSprite
onready var aliveSprite = $AliveSprite
onready var particleEmitter = $BloodParticles

var dead = false

func _ready():
	pass

func hitIceScater(collision):
	var damageToOther = damageDealt()
	if getHit(collision.collider, collision.collider.damageDealt()):
		damageToOther = 0
	collision.collider.getHit(self, damageToOther)

func setSpriteRotation(rotation):
	deadSprite.rotate(rotation)
	aliveSprite.rotate(rotation)

func kill():
	if !dead:
		deadSprite.visible = true
		aliveSprite.visible = false
		set_collision_layer_bit(1, false)
		particleEmitter.emitting = true
		dead = true
		
		get_node("../HUD/ScoreLabel").increaseScore()

func getDirection():
	if player and !dead:
		return (player.position - position).normalized()
	else:
		return Vector2(0,0)

func _process(delta):
	if dead:
		rotationSpeed *= pow(0.6, delta)
	else:
		spinUp(delta)
