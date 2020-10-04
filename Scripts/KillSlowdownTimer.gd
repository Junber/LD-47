extends Timer

func slowDown():
	start()
	Engine.time_scale /= 20

func _on_KillSlowdownTimer_timeout():
	Engine.time_scale *= 20
