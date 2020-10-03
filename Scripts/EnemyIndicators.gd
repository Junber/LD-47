extends Node2D

var indicatorScene = load("res://Scenes/EnemyIndicator.tscn")

func _on_EnemySpawnPath_enemySpawned(enemy):
	var indicator = indicatorScene.instance()
	indicator.setAssocitedEnemy(enemy)
	call_deferred("add_child", indicator)
