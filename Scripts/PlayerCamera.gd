extends Camera2D

export var screenshakyness = 100

func startScreenshake():
	$ScreenshakeTimer.start()

func _process(_delta):
	if !$ScreenshakeTimer.is_stopped():
		position += Vector2(rand_range(-screenshakyness, screenshakyness),
							rand_range(-screenshakyness, screenshakyness))
