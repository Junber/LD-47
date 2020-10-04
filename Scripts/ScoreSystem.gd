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

func endStreak():
	increaseScore(currentStreak)
	currentStreak = 0
	showStreak()

func _process(delta):
	$ComboBar.value = $ComboBar.value - delta
	if $ComboBar.value == 0:
		endStreak()

func _on_Player_playerDied():
	endStreak()
