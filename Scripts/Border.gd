extends StaticBody2D

func getHitBy(collider, collision):
	collider.collideWithWall(self, collision)

func _ready():
	pass # Replace with function body.
