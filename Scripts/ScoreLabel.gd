extends Label

var score = 0

func increaseScore():
	score += 1

func _process(_delta):
	text = str(score)
