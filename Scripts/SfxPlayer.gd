extends AudioStreamPlayer

export var pitchVariation = 0.0

func playSfx():
	pitch_scale = 1.0 + randf() * pitchVariation - pitchVariation / 2
	play()
