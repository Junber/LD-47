extends Node2D

var indicatorScene = load("res://Scenes/EnemyIndicator.tscn")

func _on_HUD_enemy_spawned(enemy):
	var indicator = indicatorScene.instance()
	indicator.setAssocitedEnemy(enemy)
	call_deferred("add_child", indicator)
