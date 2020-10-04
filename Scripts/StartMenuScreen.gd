extends TextureRect

signal button_pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	popup()

func popup():
	visible = true
	get_tree().paused = true

func go_away():
	visible = false
	get_tree().paused = false

func _on_QuitButton_pressed():
	get_tree().quit()
	emit_signal("button_pressed")

func _on_OptionsButton_pressed():
	$"../OptionsScreen".popup()
	emit_signal("button_pressed")

func _on_StartButton_pressed():
	go_away()
	emit_signal("button_pressed")
