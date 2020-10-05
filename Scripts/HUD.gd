extends CanvasLayer

signal enemy_spawned(enemy)
signal restartGame()
signal scoreChanged(score)

func _on_EnemySpawnPath_enemySpawned(enemy):
	emit_signal("enemy_spawned", enemy)

func _on_RestartButton_pressed():
	emit_signal("restartGame")

func _on_ScoreSystem_scoreChanged(score):
	emit_signal("scoreChanged", score)
