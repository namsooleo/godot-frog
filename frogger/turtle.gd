extends Area2D

signal on_turtle
signal off_turtle

func _on_body_entered(body):
	on_turtle.emit()

func _on_body_exited(body):
	off_turtle.emit()
