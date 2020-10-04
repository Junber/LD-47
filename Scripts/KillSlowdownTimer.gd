extends Timer

func slowDown():
	start()
	Engine.time_scale = 0.05

func _on_KillSlowdownTimer_timeout():
	Engine.time_scale = 1.0
