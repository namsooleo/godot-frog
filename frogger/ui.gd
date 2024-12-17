extends Control

signal start_game
@onready var main = get_node("/root/Main")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if main.game_started:
		$Score.text = "Score: %s" % main.points
		$Remaining.text = "Goals Left: %s" % main.goal_counter
	


func _on_button_pressed():
	start_game.emit()
