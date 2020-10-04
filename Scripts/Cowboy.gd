extends "res://Scripts/Enemy.gd"

var bulletScene = load("res://Scenes/Bullet.tscn")

func _on_GunTimer_timeout():
	if !dead:
		var bullet = bulletScene.instance()
		bullet.position = position
		bullet.velocity = ($"../Player".position - position).normalized() * max(2 * velocity.length(), 1000)
		bullet.position += bullet.velocity.normalized() * 70
		get_parent().add_child(bullet)
		$GunShotPlayer.play()
	else:
		$GunTimer.stop()
