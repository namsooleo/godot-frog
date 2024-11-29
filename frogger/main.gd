extends Node

@export var car_scene : PackedScene
@export var truck_scene : PackedScene
const CELL_SIZE : int = 60
const obstacle_delay : int = 50
var MAP_HEIGHT_GRID # 14 x 13 grid
var MAP_WIDTH_GRID # 14 x 13 grid
var SCREEN_SIZE
var vehicle_lanes : Array = [[], [], [], [], []]
var game_over : bool
var score : int

# Called when the node enters the scene tree for the first time.
func _ready():
	SCREEN_SIZE = $Background.texture.get_size()
	MAP_HEIGHT_GRID = SCREEN_SIZE.y / CELL_SIZE
	MAP_WIDTH_GRID = $Background.texture.get_size().x / CELL_SIZE
	$Player.position = Vector2i(((MAP_WIDTH_GRID/2)*CELL_SIZE),(MAP_HEIGHT_GRID*CELL_SIZE)-30)	
	print(vehicle_lanes.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# move cars
	for lane in range(0, vehicle_lanes.size()):
		for vehicle in vehicle_lanes[lane]:
			if lane % 2 == 0:
				vehicle.position.x -= 2
			else:
				vehicle.position.x += 4
	
func car_spawn(car_type, lane):
	var car = car_scene.instantiate()
	if lane % 2 == 0:
		car.position.x = 0 - obstacle_delay
	else:
		car.rotation = deg_to_rad(180)
		car.position.x = SCREEN_SIZE.x + obstacle_delay
	car.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - lane)) - 30
	car.get_node("car_types").set_frame(car_type)
	car.hit.connect(frog_hit )
	add_child(car)
	vehicle_lanes[lane-1].append(car)

func truck_spawn():
	var truck = truck_scene.instantiate()
	truck.position.x = SCREEN_SIZE.x + obstacle_delay
	truck.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - 5)) - 30
	truck.hit.connect(frog_hit )
	add_child(truck)
	vehicle_lanes[4].append(truck)
	
func frog_hit():
	print('dead')
	game_over = true

func _on_lane_1_timer_timeout():
	car_spawn(0, 1)

func _on_lane_2_timer_timeout():
	car_spawn(1, 2)

func _on_lane_3_timer_timeout():
	car_spawn(2, 3)

func _on_lane_4_timer_timeout():
	car_spawn(3, 4)

func _on_lane_5_timer_timeout():
	truck_spawn()
