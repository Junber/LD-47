extends Label

var score = 0;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func increaseScore():
	score += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(score)
