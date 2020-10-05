extends Path2D

onready var timer = $EnemySpawnTimer
var allEnemyScenes = [
	load("res://Scenes/Enemy.tscn"),
	load("res://Scenes/Cyborg.tscn"),
	load("res://Scenes/Knight.tscn"),
	load("res://Scenes/Cowboy.tscn"),
	load("res://Scenes/WeakEnemy.tscn")
]
var currentEnemyScenes
export var minimumSpawnDistance = 500

var numberOfEnemies = 0

signal enemySpawned(enemy)

func _ready():
	randomize()
	currentEnemyScenes = []

func setRemovedEnemies(removedEnemyIndices):
	currentEnemyScenes = allEnemyScenes.duplicate()
	for index in removedEnemyIndices:
		currentEnemyScenes.erase(allEnemyScenes[index])

func _process(_delta):
	if numberOfEnemies <= 0 and !currentEnemyScenes.empty():
		spawnEnemy()

func getNewSpawnPosition():
	return curve.interpolate_baked(randf() * curve.get_baked_length(), false)

func spawnEnemy():
	var enemy
	if !currentEnemyScenes.empty():
		var enemyScene = currentEnemyScenes[randi() % currentEnemyScenes.size()]
		enemy = enemyScene.instance()
	
		var attemptedSpawnPosition = getNewSpawnPosition()
		var player = get_node("../Player")
		
		while (player.position - attemptedSpawnPosition).length() < minimumSpawnDistance:
			attemptedSpawnPosition = getNewSpawnPosition()
		
		enemy.position = attemptedSpawnPosition
		enemy.typeIndex = allEnemyScenes.find(enemyScene)
		
		get_parent().add_child(enemy)
		enemy.connect("enemyDied", $"../WowPlayer", "playSfxEnemy")
		enemy.connect("enemyDied", $"../HUD/ScoreSystem", "enemyDied")
		enemy.connect("enemyDied", self, "enemyDied")
		enemy.connect("enemyDied", get_parent(), "enemyDied")
		enemy.connect("enemyKilledByPlayer", $"../KillSlowdownTimer", "slowDown")
		enemy.connect("enemyKilledByPlayer", $"../Player", "enemyDied")
		enemy.connect("enemyNotKilledByPlayer", $"../BooPlayer", "playSfx")
		emit_signal("enemySpawned", enemy)
		numberOfEnemies += 1
	
	timer.start(3 + pow(numberOfEnemies - 1, 2))
	
	return enemy

func enemyDied(_enemy):
	numberOfEnemies -= 1

func _on_EnemySpawnTimer_timeout():
	spawnEnemy()

func _on_Player_playerDied():
	timer.stop()
