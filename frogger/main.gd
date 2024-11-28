extends Node

@export var car_scene : PackedScene
# 14 x 13 grid
const CELL_SIZE : int = 60
const obstacle_delay : int = 50
var MAP_HEIGHT_GRID
var MAP_WIDTH_GRID
var SCREEN_SIZE

var lane_one_cars : Array = []

var game_over : bool
var score : int

# Called when the node enters the scene tree for the first time.
func _ready():
	SCREEN_SIZE = $Background.texture.get_size()
	MAP_HEIGHT_GRID = SCREEN_SIZE.y / CELL_SIZE
	MAP_WIDTH_GRID = $Background.texture.get_size().x / CELL_SIZE
	$Player.position = Vector2i(((MAP_WIDTH_GRID/2)*CELL_SIZE),(MAP_HEIGHT_GRID*CELL_SIZE)-30)	
	car_spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for car in lane_one_cars:
		car.position.x -= 5
	
func car_spawn():
	var car = car_scene.instantiate()
	car.get_node("car_types").set_frame(1)
	car.rotation = deg_to_rad(180)
	car.position.x = SCREEN_SIZE.x + obstacle_delay
	car.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - 1)) - 30
	car.hit.connect(frog_hit )
	add_child(car)
	lane_one_cars.append(car)
	
func frog_hit():
	print('dead')
	
	
