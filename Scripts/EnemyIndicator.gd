extends Node2D

var associtedEnemy = null

func setAssocitedEnemy(enemy):
	associtedEnemy = enemy
	associtedEnemy.connect("tree_exiting", self, "enemyExitingTree")

func _process(_delta):
	if !associtedEnemy:
		queue_free()
		return
	elif associtedEnemy.dead:
		queue_free()
		return
		
	var center = get_viewport_rect().size / 2
	var relEnemyPos = associtedEnemy.get_canvas_transform().xform(associtedEnemy.global_position) - center
	
	if relEnemyPos.length() < 600:
		visible = false
	else:
		visible = true
		position = center + relEnemyPos.normalized() * 500
		rotation = relEnemyPos.angle() + PI / 2

func enemyExitingTree():
	queue_free()
