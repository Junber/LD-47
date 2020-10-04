extends Control

var score = 0
var currentStreak = 0

export var comboTimeIncreasePerKill = 3

func showStreak():
	$ComboBar/StreakLabel.text = "x " + str(currentStreak)

func enemyDied():
	$ComboBar.value += comboTimeIncreasePerKill
	currentStreak += 1
	increaseScore()
	showStreak()

func increaseScore():
	score += round((pow(currentStreak, 1.5) - pow(currentStreak - 1, 1.5)) * 100)
	$ScoreLabel.text = str(score)
	$ScoreLabel.rect_position += $ScoreLabel.rect_size / 2
	$ScoreLabel.rect_scale = Vector2(2, 2)
	$ScoreLabelEffectTimer.start()

func endStreak():
	currentStreak = 0
	showStreak()

func _process(delta):
	$ComboBar.value = $ComboBar.value - delta
	if $ComboBar.value == 0:
		endStreak()
	
	if !$ScoreLabelEffectTimer.is_stopped():
		$ScoreLabel.set_rotation(rand_range(-0.1, 0.1))

func _on_Player_playerDied():
	endStreak()


func _on_ScoreLabelEffectTimer_timeout():
	$ScoreLabel.rect_scale = Vector2(1, 1)
	$ScoreLabel.set_rotation(0)
	$ScoreLabel.rect_position -= $ScoreLabel.rect_size / 2
