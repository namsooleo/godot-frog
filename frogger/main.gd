extends Node

@export var car_scene : PackedScene
@export var truck_scene : PackedScene
@export var short_log_scene : PackedScene
@export var medium_log_scene : PackedScene
@export var long_log_scene : PackedScene
@export var turtle_scene : PackedScene

const SAVE_PATH = "res://highscore" 
const CELL_SIZE : int = 60
const OBSTACLE_DELAY : int = 50
var MAP_HEIGHT_GRID # 14 x 13 grid
var MAP_WIDTH_GRID # 14 x 13 grid
var SCREEN_SIZE
var vehicle_lanes : Array = [[], [], [], [], []]
var waterways : Array = [[], [], [], [], []]
var game_over : bool
var game_playing : bool # why did I do this?
var life_counter : int
var points : int
var high_score : int
var goal_counter : int
var scored : bool
var floating : int
var over_water : bool
var scored_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	SCREEN_SIZE = get_viewport().size
	MAP_HEIGHT_GRID = SCREEN_SIZE.y / CELL_SIZE
	MAP_WIDTH_GRID = SCREEN_SIZE.x / CELL_SIZE
	$Player.position = Vector2i(((MAP_WIDTH_GRID/2)*CELL_SIZE),(MAP_HEIGHT_GRID*CELL_SIZE)-30)	
	
	# Pre-spawn obstacles 
	pre_spawn()
	
	# setting vars
	points = 0 
	goal_counter = 5
	life_counter = 3
	scored = false
	over_water = false
	floating = 0
	# load and set high score
	load_high_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	if not game_over:
		check_drowning()
		points += 1
	
		# move cars
		for lane in range(0, vehicle_lanes.size()):
			for vehicle in vehicle_lanes[lane]:
				match lane:
					0:
						vehicle.position.x -= 2
					1: 
						vehicle.position.x += 1.9
					2:
						vehicle.position.x -= 3
					3:
						vehicle.position.x += 3
					4: 
						vehicle.position.x -= 1.6
					_:
						print('you broke the game')
		
		# Move logs & turtles
		for current in range(0, waterways.size()):
			for platform in waterways[current]:
				match current:
					0:
						platform.position.x += 1.7
					1:
						platform.position.x += 2.2
					2: 
						platform.position.x -= 2.5
					3:
						platform.position.x += 3
					4:
						platform.position.x -= 1.9
					_:
						print('you broke the game')
			
		if floating:
			if $Player.position.y / 60 == 5.5:
				$Player.position.x += 1.7
			elif $Player.position.y / 60 == 4.5:
				$Player.position.x += 2.2
			elif $Player.position.y / 60 == 3.5:
				$Player.position.x -= 2.5
			elif $Player.position.y / 60 == 2.5:
				$Player.position.x += 3
			elif $Player.position.y / 60 == 1.5:
				$Player.position.x -= 1.9
		
		if scored:
			points += 100
			var node_name = "PlayerGoal%s" % goal_counter
			$Background.add_player_sprite($Player.position, node_name)
			$Player.hide()
			$Player.position = Vector2i(((MAP_WIDTH_GRID/2)*CELL_SIZE),(MAP_HEIGHT_GRID*CELL_SIZE)-30)	
			$Player.show()
			scored = false
			
		if $Background.get_node_or_null("PlayerGoal%s" % goal_counter):
			$Background.get_node("PlayerGoal%s" % goal_counter).position = \
				$Background.get_node("PlayerGoal%s" % goal_counter).position.lerp(scored_position, delta*2)			
	

func car_spawn(car_type, lane):
	# pick car sprite, rotate, set traffic lanes
	var car = car_scene.instantiate()
	if lane % 2 == 0:
		car.position.x = 0 - OBSTACLE_DELAY
	else:
		car.rotation = deg_to_rad(180)
		car.position.x = SCREEN_SIZE.x + OBSTACLE_DELAY
	car.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - lane)) - (CELL_SIZE/2)
	car.get_node("car_types").set_frame(car_type)
	car.hit.connect(frog_hit )
	add_child(car)
	vehicle_lanes[lane-1].append(car)

func truck_spawn():
	var truck = truck_scene.instantiate()
	truck.position.x = SCREEN_SIZE.x + OBSTACLE_DELAY
	# subtract grid count to put truck into desired traffic lane
	truck.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - 5)) - (CELL_SIZE/2)
	truck.hit.connect(frog_hit)
	add_child(truck)
	vehicle_lanes[4].append(truck) # 4 is the 5 lane of traffic

func short_log_spawn():
	var short_log = short_log_scene.instantiate()
	short_log.position.x = 0 - (OBSTACLE_DELAY * 2)
	# subtract grid count to put log into desired waterway lane; -7
	short_log.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - 7)) - (CELL_SIZE/2) 
	short_log.on_log.connect(on_platform)
	short_log.off_log.connect(off_platform)
	add_child(short_log)
	waterways[0].append(short_log)

func med_log_spawn():
	var med_log = medium_log_scene.instantiate()
	med_log.position.x = SCREEN_SIZE.x + (OBSTACLE_DELAY * 3)
	# subtract grid count to put log into desired waterway lane
	med_log.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - 11)) - (CELL_SIZE/2)
	med_log.on_log.connect(on_platform)
	med_log.off_log.connect(off_platform)
	add_child(med_log)
	waterways[4].append(med_log)
	
func long_log_spawn():
	var long_log = long_log_scene.instantiate()
	long_log.position.x = SCREEN_SIZE.x + (OBSTACLE_DELAY * 4)
	# subtract grid count to put log into desired waterway lane
	long_log.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - 9)) - (CELL_SIZE/2)
	long_log.on_log.connect(on_platform)
	long_log.off_log.connect(off_platform)
	add_child(long_log)
	waterways[2].append(long_log)
	
func spawn_turtles(waterway):
	var turtles = turtle_scene.instantiate()
	turtles.position.x = 0 - (OBSTACLE_DELAY * 4)
	# desired waterway lane and +6 to account for traffic lanes and ground
	turtles.position.y = (CELL_SIZE * (MAP_HEIGHT_GRID - (waterway + 6))) - (CELL_SIZE/2)
	turtles.on_turtle.connect(on_platform)
	turtles.off_turtle.connect(off_platform)
	add_child(turtles)
	waterways[waterway-1].append(turtles)

func on_platform():
	floating += 1

func off_platform():
	floating -= 1
	
func _on_background_enter_water():
	over_water = true

func _on_background_exit_water():
	over_water = false

func check_drowning():
	if floating == 0 and over_water == true:
		end_game()

func frog_hit():
	end_game()
		
func end_game():
	game_over = true
	game_playing = false
	
	$Player.play_death()
	stop_timers()
	if life_counter > 1:
		$ui/Button.text = "Restart?"
	elif life_counter == 1:
		$ui/Button.text = "Game Over"
	$ui/Lives.get_node("Life%s" % life_counter).hide()
	life_counter -= 1
	$ui/Button.show()
	if points > high_score:
		save_score()

func _on_background_goal_hit(goal_position, goal_sprite):
	scored = true
	goal_counter -= 1
	scored_position = goal_position
	goal_sprite.hide()

func _on_ui_start_game():
	$ui/Button.hide()
	if life_counter == 0:
		points = 0 
		goal_counter = 5
		for x in range(1,4):
			$ui/Lives.get_node("Life%s" % x).show()
		life_counter = 3
	game_playing = true
	game_over = false
	scored = false
	over_water = false
	floating = 0
	$Player.position = Vector2i(((MAP_WIDTH_GRID/2)*CELL_SIZE),(MAP_HEIGHT_GRID*CELL_SIZE)-30)
	$Player/AnimatedSprite2D.animation = "jump"
	$Player/AnimatedSprite2D.set_frame(0)
	start_timers()
	if points > high_score:
		$ui/Highscore.text = "Best: %s" % points



# Object spawner timers
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

func _on_waterway_1_timer_timeout():
	short_log_spawn()

func _on_waterway_2_timer_timeout():
	spawn_turtles(2)

func _on_waterway_3_timer_timeout():
	long_log_spawn()

func _on_waterway_4_timer_timeout():
	spawn_turtles(4)

func _on_waterway_5_timer_timeout():
	med_log_spawn()

func stop_timers():
	$lane1_timer.stop()
	$lane2_timer.stop()
	$lane3_timer.stop()
	$lane4_timer.stop()
	$lane5_timer.stop()
	$waterway1_timer.stop()
	$waterway2_timer.stop()
	$waterway3_timer.stop()
	$waterway4_timer.stop()
	$waterway5_timer.stop()

func start_timers():
	$lane1_timer.start()
	$lane2_timer.start()
	$lane3_timer.start()
	$lane4_timer.start()
	$lane5_timer.start()
	$waterway1_timer.start()
	$waterway2_timer.start()
	$waterway3_timer.start()
	$waterway4_timer.start()
	$waterway5_timer.start()
	
func pre_spawn():
	car_spawn(0, 1)
	car_spawn(1, 2)
	car_spawn(2, 3)
	car_spawn(3, 4)
	truck_spawn()
	spawn_turtles(2)
	spawn_turtles(4)
	short_log_spawn()
	long_log_spawn()
	med_log_spawn()

# copied from old code
func save_score():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"High Score": points
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func load_high_score():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				high_score = current_line["High Score"]
