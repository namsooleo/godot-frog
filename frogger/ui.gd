extends Control

signal start_game
@onready var main = get_node("/root/Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if main.game_playing:
		$Score.text = "Score: %s" % main.points
		$Goals.text = "Goals: %s" % main.goal_counter
		$Highscore.text = "Best: %s" % main.high_score
	


func _on_button_pressed():
	start_game.emit()
