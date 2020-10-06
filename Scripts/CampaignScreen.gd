extends TextureRect

signal button_pressed()
signal campaignChosen(flavourful)

func _on_BareButton_pressed():
	visible = false
	emit_signal("campaignChosen", false)
	emit_signal("button_pressed")
	
func _on_FlavourButton_pressed():
	visible = false
	emit_signal("campaignChosen", true)
	emit_signal("button_pressed")
