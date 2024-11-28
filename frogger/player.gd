extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# frog = 60x60
# bg = 840x780
# 14 x 13 grid

func _ready():
	self.position = Vector2i(500,200)	
	print("60 x 60")

func _physics_process(delta):
	
	if Input.is_action_just_pressed("move_up"):
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.rotation = deg_to_rad(0)
		self.position.y = self.position.y - 60
	elif Input.is_action_just_pressed("move_right"):
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.rotation = deg_to_rad(90)
		self.position.x = self.position.x + 60
	elif Input.is_action_just_pressed("move_down"):
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.rotation = deg_to_rad(180)
		self.position.y = self.position.y + 60
	elif Input.is_action_just_pressed("move_left"):
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.rotation = deg_to_rad(270)
		self.position.x = self.position.x - 60

	move_and_slide()
