extends Node2D

signal allZonesTouched

var zonesLeft = 5

func decreaseZonesLeft():
	zonesLeft -= 1
	if zonesLeft <= 0:
		emit_signal("allZonesTouched")

func _on_Zone_body_entered(_body):
	$Zone.queue_free()
	decreaseZonesLeft()

func _on_Zone2_body_entered(_body):
	$Zone2.queue_free()
	decreaseZonesLeft()

func _on_Zone3_body_entered(_body):
	$Zone3.queue_free()
	decreaseZonesLeft()

func _on_Zone4_body_entered(_body):
	$Zone4.queue_free()
	decreaseZonesLeft()

func _on_Zone5_body_entered(_body):
	$Zone5.queue_free()
	decreaseZonesLeft()
