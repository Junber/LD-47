extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0

onready var camera = get_parent()

func start(duration = 0.3, frequency = 20, newAmplitude = 30):
	amplitude = newAmplitude
	$Duration.wait_time = duration
	$Frequency.wait_time = 1 / float(frequency)
	$Duration.start()
	$Frequency.start()
	
	_new_shake()

func _new_shake():
	var randomOffset = Vector2(rand_range(amplitude, -amplitude),
								 rand_range(amplitude, -amplitude))
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, randomOffset, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func _reset():
	$ShakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()	

func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
