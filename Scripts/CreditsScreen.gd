extends TextureRect

signal button_pressed()

func _on_YesButton_pressed():
	visible = false
	emit_signal("button_pressed")
