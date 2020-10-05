extends Node2D

export(String, FILE) var saveFileName = "user://Save.save"

var gameScene = load("res://Scenes/Game.tscn")
var tutorialProgress = 1
var previousPauseState
var game = null

func _ready():
	get_tree().paused = true
	loadProgress()
	if tutorialProgress != 1:
		$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/StartButton".text = "Continue"
		$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/DeleteButton".disabled = false
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		saveProgress()

func quitGame():
	saveProgress()
	get_tree().quit()
	
func restartLevel():
	if game:
		game.queue_free()
	game = gameScene.instance()
	add_child(game)
	game.setTutorialProgress(tutorialProgress)
	game.print_next_dialog_line()
	game.connect("restartGame", self, "_on_Game_restartGame")
	game.inMenu = false

func restartGame():
	saveProgress()
	#warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().paused = false


func saveProgress():
	var progressData = {
		"tutorialProgress" : tutorialProgress
	}
	
	var saveFile = File.new()
	saveFile.open(saveFileName, File.WRITE)
	saveFile.store_line(to_json(progressData))
	saveFile.close()
	
	$"MenuScreenLayer/OptionsScreen".save_options()

func loadProgress():
	var saveFile = File.new()
	if not saveFile.file_exists(saveFileName):
		return

	saveFile.open(saveFileName, File.READ)
	var optionsData = parse_json(saveFile.get_line())
	
	if optionsData.has("tutorialProgress"):
		tutorialProgress = optionsData["tutorialProgress"]
	
	restartLevel()


func _on_MenuScreen_restart_game():
	restartGame()

func _on_MenuScreen_restart_level():
	restartLevel()

func _on_StartMenuScreen_quit_game():
	quitGame()

func _on_MenuScreen_quit_game():
	quitGame()

func _on_MenuScreen_pause():
	previousPauseState = get_tree().paused
	get_tree().paused = true
	game.inMenu = true

func _on_MenuScreen_unpause():
	get_tree().paused = previousPauseState
	game.inMenu = false

func _on_StartMenuScreen_start_game():
	game.inMenu = false

func _on_DeleteScreen_deleteSaveData():
	tutorialProgress = 1
	$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/StartButton".text = "New Game"
	$"MenuScreenLayer/StartMenuScreen/MarginContainer/VBoxContainer/DeleteButton".disabled = true
	saveProgress()

func _on_Game_restartGame():
	restartLevel()
