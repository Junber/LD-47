extends "res://Scripts/Enemy.gd"

var bulletScene = load("res://Scenes/Bullet.tscn")

func _on_GunTimer_timeout():
	if !dead:
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.velocity = ($"../Player".position - position).normalized() * max(2 * velocity.length(), 1000)
		bullet.position += bullet.velocity.normalized() * 100
		get_parent().add_child(bullet)
		$GunShotPlayer.play()
		$GunCockingTimer.start()
	else:
		$GunTimer.stop()


func _on_GunCockingTimer_timeout():
	if !dead:
		$GunCockingPlayer.play()
