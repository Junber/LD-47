extends Label

var spinning = false

func changeText(newNumber):
	text = str(newNumber)
	spinning = true
	$SpinTimer.start(PI / 10)

func resetSpinning():
	spinning = false
	rect_rotation = 0
	

func _process(delta):
	if spinning:
		rect_rotation += delta * 1000


func _on_SpinTimer_timeout():
	spinning = false
	rect_rotation = 0
