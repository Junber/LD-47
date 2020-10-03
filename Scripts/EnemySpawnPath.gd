extends Path2D

var enemyScene = load("res://Scenes/Enemy.tscn")
export var minimumSpawnDistance = 500


func _ready():
	pass

func getNewSpawnPosition():
	return curve.interpolate_baked(randf() * curve.get_baked_length(), false)

func _on_EnemySpawnTimer_timeout():
	var enemy = enemyScene.instance()
	
	var attemptedSpawnPosition = getNewSpawnPosition()
	var player = get_node("../Player")
	
	while (player.position - attemptedSpawnPosition).length() < minimumSpawnDistance:
		attemptedSpawnPosition = getNewSpawnPosition()
	
	enemy.position = attemptedSpawnPosition
	
	get_parent().add_child(enemy)
