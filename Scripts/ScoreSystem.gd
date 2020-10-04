extends Control

var score = 0
var currentStreak = 0

export var comboTimeIncreasePerKill = 3

func showStreak():
	$ComboBar/StreakLabel.text = "x " + str(currentStreak)

func enemyDied():
	$ComboBar.value += comboTimeIncreasePerKill
	currentStreak += 1
	showStreak()

func increaseScore(_amount):
	score += round(pow(currentStreak, 1.5)) * 100
	$ScoreLabel.text = str(score)

func _process(delta):
	$ComboBar.value = $ComboBar.value - delta
	print($ComboBar.value)
	if $ComboBar.value == 0:
		increaseScore(currentStreak)
		currentStreak = 0
		showStreak()

func _ready():
	pass # Replace with function body.
