extends Path2D

var enemyScene = load("res://Scenes/Enemy.tscn")

func _ready():
	pass

func _on_EnemySpawnTimer_timeout():
	var enemy = enemyScene.instance()
	enemy.position = curve.interpolate_baked(randf() * curve.get_baked_length(), false)
	get_parent().add_child(enemy)
