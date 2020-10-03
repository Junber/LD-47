extends Path2D

onready var timer = $EnemySpawnTimer
var enemyScenes = [
	load("res://Scenes/Enemy.tscn"),
	load("res://Scenes/Cyborg.tscn")
]
export var minimumSpawnDistance = 500


func _ready():
	spawnEnemy()

func getNewSpawnPosition():
	return curve.interpolate_baked(randf() * curve.get_baked_length(), false)

func spawnEnemy():
	var enemy = enemyScenes[randi() % enemyScenes.size()].instance()
	
	var attemptedSpawnPosition = getNewSpawnPosition()
	var player = get_node("../Player")
	
	while (player.position - attemptedSpawnPosition).length() < minimumSpawnDistance:
		attemptedSpawnPosition = getNewSpawnPosition()
	
	enemy.position = attemptedSpawnPosition
	
	get_parent().call_deferred("add_child", enemy)
	enemy.connect("enemyDied", $"../WowPlayer", "playSfx")
	enemy.connect("enemyDidNotDie", $"../BooPlayer", "playSfx")

func _on_EnemySpawnTimer_timeout():
	spawnEnemy()

func _on_Player_playerDied():
	timer.stop()
