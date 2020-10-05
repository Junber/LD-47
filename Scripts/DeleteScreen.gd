extends TextureRect

signal button_pressed()
signal deleteSaveData()

func _on_YesButton_pressed():
	visible = false
	emit_signal("deleteSaveData")
	emit_signal("button_pressed")
	
func _on_NoButton_pressed():
	visible = false
	emit_signal("button_pressed")
