extends Label

var spinning = false

func changeText(newNumber):
	text = str(newNumber)
	spinning = true
	yield(get_tree().create_timer(PI / 10), "timeout")
	spinning = false

func resetSpinning():
	spinning = false
	rect_rotation = 0
	

func _process(delta):
	if spinning:
		rect_rotation += delta * 1000
	else:
		rect_rotation = 0
