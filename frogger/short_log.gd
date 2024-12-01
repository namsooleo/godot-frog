extends Sprite2D

signal on_log
signal off_log

func _on_area_2d_body_entered(body):
	on_log.emit()


func _on_area_2d_body_exited(body):
	off_log.emit()
