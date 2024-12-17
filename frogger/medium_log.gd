extends Area2D

signal on_log
signal off_log

func _on_body_entered(body):
	on_log.emit()

func _on_body_exited(body):
	off_log.emit()
