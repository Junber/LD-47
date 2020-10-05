extends Node2D

signal restartGame()

onready var textbox = $"HUD/TextBox"

var dialogProgress = 0
var tutorialProgress = 0
var dialog = []
var inMenu = true

var itemDropRate = 0.7
var enemiesLeftToKill = 0
var enemiesToCount = -1
var scoreToReach = 0

func _input(event):
	if !inMenu and event.is_action_pressed("advance"):
		if not textbox.all_text_appeared():
			textbox.show_all_text()
		else:
			print_next_dialog_line()
	
func setTutorialProgress(newTutorialProgress):
	tutorialProgress = newTutorialProgress
	dialogProgress = 0
	if tutorialProgress in [4, 5]:
		get_parent().tutorialProgress = 3
	elif tutorialProgress in [9, 10]:
		get_parent().tutorialProgress = 8
	elif tutorialProgress == 13:
		get_parent().tutorialProgress = 12
	elif tutorialProgress == 17:
		get_parent().tutorialProgress = 16
	else:
		get_parent().tutorialProgress = newTutorialProgress
		
	loadDialog()
	loadTutorialSpecificNodes()
	loadTutorialRemovedEnemies()
	loadTutorialItemDropRate()

func progressInTutorial():
	setTutorialProgress(tutorialProgress + 1)
	print_next_dialog_line()


func loadTutorialSpecificNodes():
	if tutorialProgress == 1:
		var zones = load("res://Scenes/Zones.tscn").instance()
		zones.connect("allZonesTouched", self, "allZonesTouched")
		add_child(zones, true)
	elif tutorialProgress == 3:
		$EnemySpawnPath.setRemovedEnemies([0,1,2,3])
		var enemy = $EnemySpawnPath.spawnEnemy()
		enemy.connect("enemyNotKilledByPlayer", self, "playerAttacked")
		$Player.frozen = true
		$Player.velocity = Vector2(0,0)
		$Player.rotationSpeed = 0
	elif tutorialProgress == 6:
		resetItemStuff()
		setEnemiesLeftToKill(5)
		enemiesToCount = -1
	elif tutorialProgress == 7:
		resetItemStuff()
		setEnemiesLeftToKill(5)
		enemiesToCount = -1
	elif tutorialProgress == 8:
		resetItemStuff()
		$EnemySpawnPath.setRemovedEnemies([0,1,2,4])
		$EnemySpawnPath.spawnEnemy()
		setEnemiesLeftToKill(1)
		enemiesToCount = -1
	elif tutorialProgress == 11:
		resetItemStuff()
		setEnemiesLeftToKill(5)
		enemiesToCount = 3
	elif tutorialProgress == 12:
		resetItemStuff()
		$EnemySpawnPath.setRemovedEnemies([0,1,3,4])
		$EnemySpawnPath.spawnEnemy()
		setEnemiesLeftToKill(1)
		enemiesToCount = -1
	elif tutorialProgress == 14:
		resetItemStuff()
		setEnemiesLeftToKill(5)
		enemiesToCount = 2
	elif tutorialProgress == 15:
		resetItemStuff()
		setEnemiesLeftToKill(10)
		enemiesToCount = -1
	elif tutorialProgress == 16:
		resetItemStuff()
		$EnemySpawnPath.setRemovedEnemies([0,2,3,4])
		$EnemySpawnPath.spawnEnemy()
		setEnemiesLeftToKill(1)
		enemiesToCount = -1
	elif tutorialProgress == 18:
		resetItemStuff()
		setEnemiesLeftToKill(5)
		enemiesToCount = 1
	elif tutorialProgress == 19:
		resetItemStuff()
		setEnemiesLeftToKill(15)
		enemiesToCount = -1
	elif tutorialProgress == 20:
		resetItemStuff()
		$HUD/ScoreSystem.score = 0
		scoreToReach = 15000

func loadTutorialItemDropRate():
	if tutorialProgress in [1,2,3,4,5, 8,9,10, 12,13, 16,17]:
		itemDropRate = 1
	else:
		itemDropRate = 0.75

func loadTutorialRemovedEnemies():
	if tutorialProgress in [1,2,3,4,5, 8,9,10, 12,13, 16,17]:
		$EnemySpawnPath.setRemovedEnemies([0,1,2,3,4])
	elif tutorialProgress == 6:
		$EnemySpawnPath.setRemovedEnemies([0,1,2,3])
	elif tutorialProgress == 7:
		$EnemySpawnPath.setRemovedEnemies([1,2,3,4])
	elif tutorialProgress == 11:
		$EnemySpawnPath.setRemovedEnemies([1,2,4])
	elif tutorialProgress == 14:
		$EnemySpawnPath.setRemovedEnemies([1,3,4])
	elif tutorialProgress == 15:
		$EnemySpawnPath.setRemovedEnemies([1,4])
	elif tutorialProgress == 18:
		$EnemySpawnPath.setRemovedEnemies([2,3,4])
	else:
		$EnemySpawnPath.setRemovedEnemies([4])


func loadDialog():
	dialog = []
	
	var dialogFile = File.new()
	var filename = "res://Resources/Dialog/"+str(tutorialProgress)+".txt"
	if not dialogFile.file_exists(filename):
		return
	
	dialogFile.open(filename, File.READ)
	while !dialogFile.eof_reached():
		var line = dialogFile.get_line()
		dialog.append(line)

func print_next_dialog_line():
	if dialogProgress >= dialog.size():
		hideDialog()
		if tutorialProgress == 21:
			progressInTutorial()
	else:
		showDialog(dialog[dialogProgress])
		dialogProgress += 1

func hideDialog():
	textbox.visible = false
	get_tree().paused = false
	$"HUD/ScoreSystem/ComboBar/DecreasingOfBar".emitting = true
	$"HUD/ScoreSystem/ComboBar/DecreasingOfBar".speed_scale = 1

func showDialog(line):
	textbox.set_text(line)
	textbox.set_name("You:")
	textbox.visible = true
	get_tree().paused = true
	$"HUD/ScoreSystem/ComboBar/DecreasingOfBar".emitting = false
	$"HUD/ScoreSystem/ComboBar/DecreasingOfBar".speed_scale = 0

func freeAllEnemies():
	get_tree().call_group("enemies", "queue_free")
	$EnemySpawnPath.numberOfEnemies = 0

func allZonesTouched():
	if tutorialProgress == 1:
		$Zones.queue_free()
		progressInTutorial()
	
func _on_Player_boosted():
	if tutorialProgress == 2:
		yield(get_tree().create_timer(0.2), "timeout")
		progressInTutorial()

func playerAttacked():
	if tutorialProgress == 3:
		yield(get_tree().create_timer(0.2), "timeout")
		$Player.frozen = false
		progressInTutorial()

func resetItemStuff():
	get_tree().call_group("items", "queue_free")
	
	$Player.setBulletsLeft(0)
	
	if !$"Player/ShieldTimer".is_stopped():
		$"Player/ShieldTimer".start(0.01)
		
	if !$"Player/SlowdownTimer".is_stopped():
		$"Player/SlowdownTimer".start(0.01)

func setEnemiesLeftToKill(newAmount, stopSpinning = true):
	enemiesLeftToKill = newAmount
	$"HUD/EnemiesLeftLabel".changeText(enemiesLeftToKill)
	if stopSpinning:
		$"HUD/EnemiesLeftLabel".resetSpinning()
		
	$"HUD/EnemiesLeftLabel".visible = enemiesLeftToKill > 0
	$"HUD/EnemiesLeftIcon".visible = enemiesLeftToKill > 0

func decreaseEnemiesLeft():
	setEnemiesLeftToKill(enemiesLeftToKill - 1, false)
	if enemiesLeftToKill <= 0:
		yield(get_tree().create_timer(0.2), "timeout")
		freeAllEnemies()
		progressInTutorial()
		
func enemyDied(enemy):
	if tutorialProgress == 4:
		yield(get_tree().create_timer(0.2), "timeout")
		progressInTutorial()
	elif enemiesLeftToKill and (enemiesToCount < 0 or enemiesToCount == enemy.typeIndex):
		decreaseEnemiesLeft()

func itemPickedUp():
	if tutorialProgress in [5, 9, 13, 17]:
		yield(get_tree().create_timer(0.1), "timeout")
		progressInTutorial()

func _on_Player_shot():
	if tutorialProgress == 10 and $Player.bulletsLeft == 0:
		yield(get_tree().create_timer(0.5), "timeout")
		progressInTutorial()

func _on_HUD_restartGame():
	emit_signal("restartGame")


func _on_HUD_scoreChanged(score):
	if scoreToReach and score >= scoreToReach:
		yield(get_tree().create_timer(0.2), "timeout")
		progressInTutorial()
