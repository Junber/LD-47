extends CanvasLayer

signal enemy_spawned(enemy)

func _on_EnemySpawnPath_enemySpawned(enemy):
	emit_signal("enemy_spawned", enemy)
