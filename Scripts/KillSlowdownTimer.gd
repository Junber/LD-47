extends Timer

var timeMultiplier = 1

func slowDown():
	if is_stopped():
		start()
		timeMultiplier = 20 * sqrt(Engine.time_scale)
		Engine.time_scale /= timeMultiplier

func _on_KillSlowdownTimer_timeout():
	Engine.time_scale *= timeMultiplier
