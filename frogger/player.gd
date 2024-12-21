extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var main = get_node("/root/Main")
# frog = 60x60
# bg = 840x780
# 14 x 13 grid

func _ready():
	self.position = Vector2i(500,200)	# for testing scene

func _physics_process(delta):
	if main.game_playing:
		if Input.is_action_just_pressed("move_up"):
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.rotation = deg_to_rad(0)
			if self.position.y > 60:
				self.position.y = self.position.y - 60
		elif Input.is_action_just_pressed("move_right"):
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.rotation = deg_to_rad(90)
			if self.position.x < 780: # based on screen width + testing
				self.position.x = self.position.x + 60
		elif Input.is_action_just_pressed("move_down"):
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.rotation = deg_to_rad(180)
			if self.position.y < 750:
				self.position.y = self.position.y + 60
		elif Input.is_action_just_pressed("move_left"):
			$AnimatedSprite2D.play("jump")
			$AnimatedSprite2D.rotation = deg_to_rad(270)
			if self.position.x > 60:
				self.position.x = self.position.x - 60

	move_and_slide()

func play_death():
	$AnimatedSprite2D.play("death")
	
