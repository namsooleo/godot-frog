extends Sprite2D

signal drown

func _on_area_2d_body_entered(body):
	drown.emit()
