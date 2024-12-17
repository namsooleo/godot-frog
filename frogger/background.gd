extends Sprite2D

signal enter_water
signal exit_water
signal goal_hit(goal_position, goal_sprite)

func _on_background_body_entered(body):
	enter_water.emit()

func _on_background_body_exited(body):
	exit_water.emit()

func _on_goal_area_1_body_entered(body):
	var goal_node = self.get_node("Goal1")
	goal_hit.emit(goal_node.position, goal_node)

func _on_goal_area_2_body_entered(body):
	var goal_node = self.get_node("Goal2")
	goal_hit.emit(goal_node.position, goal_node)

func _on_goal_area_3_body_entered(body):
	var goal_node = self.get_node("Goal3")
	goal_hit.emit(goal_node.position, goal_node)

func _on_goal_area_4_body_entered(body):
	var goal_node = self.get_node("Goal4")
	goal_hit.emit(goal_node.position, goal_node)

func _on_goal_area_5_body_entered(body):
	var goal_node = self.get_node("Goal5")
	goal_hit.emit(goal_node.position, goal_node)

func add_player_sprite(player_pos, name):
	var sprite = Sprite2D.new()
	sprite.name = name
	sprite.texture = preload("res://assets/frog.png")
	sprite.region_enabled = true
	var region_position = Vector2(2,0) * Vector2(60,60) # cell index * cell size
	sprite.region_rect = Rect2(region_position, Vector2(60,60))
	sprite.position = player_pos
	add_child(sprite)
	return sprite

