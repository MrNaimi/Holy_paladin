extends Node2D
#Tätä hommaa ajetaan seuraavalla tavalla:
#Proc_world_gen nodessa on noise ominaisuus, mapin ulkonäköä voi muuttaa vaihtamalla noise ja color ramp asetuksia.
#Noise osiossa voi vaihtaa millä "ääni" mallilla godot luo kartan, kannattaa pitää celullar generointi päällä.
# Vaihtamalla "seed" arvoa voi vaihtaa tämänhetkisten asetusten pohjalta eri mappeja.
#jos vaihtaa cellular:ista johonkin toiseen kannattaa katsoa min ja max printit ja vaihtaa generate_world() kohtaan
# sopivat arvot if-lauseisiin
@export var noise_height_text : NoiseTexture2D
var noise : Noise #Noise proc_gen_world
var width : int = 150
var height : int = 150

var source_id = 0 #helvetti Tilesetin id
var lava_atlas = Vector2i(0,8) #lavan kordinaatti tilesetissä
var land_atlas = Vector2i(1,0) #maan kordinaatti tilesetissä
var ground2_atlas = Vector2i(9,4)

var forest_id = 1
var tree_id = 2
var water_atlas = Vector2i(4,8) #veden kordinaatti tilesetissä
var grass_atlas = Vector2i(5,2) #ruohon kordinaatti tilesetissä
var tree_atlas = Vector2i(0,0)# puu kordinaatti

#tileset kytkin
var kohtaus = 1

#kamera, kyl te tiedätte
@onready var camera_2d = $"../../Player/Camera2D"

#helvetti tilet
@onready var lava_tilemaplayer = $lava
@onready var ground_tilemaplayer = $ground
@onready var ground2_tilemaplayer = $ground2
@onready var environment_tilemaplayer = $environment

#overworld tilet
@onready var water_tilemaplayer: TileMapLayer = $water
@onready var grass_tilemaplayer: TileMapLayer = $grass
@onready var rocks_tilemaplayer: TileMapLayer = $rocks
@onready var tree_tilemaplayer: TileMapLayer = $nature
#helvetti tilet
var ground_tiles_arr =[] 
var terrain_ground_int = 1 #Ground tilejen layer numero
var lava_tiles_arr =[]
var terrain_lava_int = 0 #Laavan layer numero
var ground2_tiles_arr =[]
var terrain_ground2_int = 2

#overworld tilet
var grass_tiles_arr =[]
var terrain_grass_int = 1
var water_tiles_arr =[]
var terrain_water_int = 0
var tree_tiles_arr = []
var terrain_tree_int = 3

var noise_val_arr =[]

func _input(event): #zoom control, helpompi kattoa karttaa 
	if Input.is_action_just_pressed("zoomout"):
		var zoom_val = camera_2d.zoom.x + 0.1
		camera_2d.zoom = Vector2(zoom_val,zoom_val)
	if Input.is_action_just_pressed("zoomin"):
		var zoom_val = camera_2d.zoom.x - 0.1
		camera_2d.zoom = Vector2(zoom_val,zoom_val)

func _ready():
	noise = noise_height_text.noise
	#noise.seed = RandomNumberGenerator.new().randi_range(0,200)
	generate_world()
	generate_road(START_POS, END_POS)

func spawn_player():
	pass
	
func generate_world():
	#Käydään koko map läpi eli 100 x 200, josta tulee neljö isometric tilet on 32x16. 
	if kohtaus == 1:
		for x in range(-width/2, width/2):
			for y in range(-height/2, height/2):
				var noise_val: float = noise.get_noise_2d(x, y)
				#print("Noise value at position ", Vector2i(x, y), ": ", noise_val)
				noise_val_arr.append(noise_val)
				
				#jos generoidun "äänen" arvo on <=-0.5 
				if noise_val <=-0.4:
					if noise_val <=-0.70:
						ground2_tiles_arr.append(Vector2i(x,y))
						ground2_tilemaplayer.set_cell(Vector2i(x,y), source_id, ground2_atlas)
					#place land
					ground_tiles_arr.append(Vector2i(x,y))
					ground_tilemaplayer.set_cell(Vector2i(x,y),source_id, land_atlas)
					
				elif noise_val > -0.45987845468521:
					#place lava
					lava_tiles_arr.append(Vector2i(x,y))
					lava_tilemaplayer.set_cell(Vector2i(x,y),source_id,lava_atlas)
	#testinä äänen korkein ja pienin arvo, eri kuvioilla on eri arvot niin pitää säätää elif noise_val > -0.5: if noise_val <=-0.5: sopiviksi
	if kohtaus == 0:
		for x in range(-width,width):
			for y in range(-height, height):
				var noise_val : float = noise.get_noise_2d(x,y)
				noise_val_arr.append(noise_val)
				
				if noise_val <=-0.45:
					if noise_val < -0.80:
						tree_tiles_arr.append(Vector2i(x,y))
						tree_tilemaplayer.set_cell(Vector2i(x,y),tree_id,tree_atlas)
					#place grass
					grass_tiles_arr.append(Vector2i(x,y))
					grass_tilemaplayer.set_cell(Vector2i(x,y),forest_id, grass_atlas)
					
				elif noise_val > -0.45:
					#place water
					water_tiles_arr.append(Vector2i(x,y))
					water_tilemaplayer.set_cell(Vector2i(x,y),forest_id,water_atlas)
				
	print("Noise map korkein arvo:  ", noise_val_arr.max())
	print("Noise map pienin arvo: ", noise_val_arr.min())
	
	grass_tilemaplayer.set_cells_terrain_connect(grass_tiles_arr,terrain_grass_int,0)
	water_tilemaplayer.set_cells_terrain_connect(water_tiles_arr,terrain_water_int,0)
	tree_tilemaplayer.set_cells_terrain_connect(tree_tiles_arr,terrain_tree_int,0)
	ground_tilemaplayer.set_cells_terrain_connect(ground_tiles_arr,terrain_ground_int,0)
	lava_tilemaplayer.set_cells_terrain_connect(lava_tiles_arr,terrain_lava_int,0)
	ground2_tilemaplayer.set_cells_terrain_connect(ground2_tiles_arr,terrain_ground2_int,0)


var road_tiles_arr = 2
var road_id = 5
var road_atlas = Vector2i(6,5)
@onready var road_tilemaplayer = $road
const INF = 999999999999.0
var START_POS = Vector2i(0,0)  # Replace with actual start position
var END_POS = Vector2i(74, 60)  # Replace with actual end position

var grid_size: Vector2i = Vector2i(75, 75)  # Adjust based on your map size

func get_noise_value(pos: Vector2i) -> float:
	var index: int = (pos.y + grid_size.y) * (2 * grid_size.x) + (pos.x + grid_size.x)
	var noise_value = noise_val_arr[index]  
	#print("Noise value at ", pos, ":", noise_value)
	return noise_value  

func is_valid_tile(pos: Vector2i) -> bool:
	# Adjusting the bounds check to handle negative positions
	if pos.x < -grid_size.x  or pos.y < -grid_size.y  or pos.x >= grid_size.x  or pos.y >= grid_size.y :
		#print("Tile out of bounds:", pos)
		return false  # Out of bounds
	
	var noise_val: float = get_noise_value(pos)
	# Ensure the correct noise range is used for valid road placement
	var valid = noise_val >= -0.7 and noise_val <= -0.4  
	# Debugging print to check if we're allowing lava tiles
	#print("Checking tile at:", pos, "| Noise:", noise_val, "| Valid:", valid)
	return valid


func heuristic(a: Vector2i, b: Vector2i) -> float:
	var h = (a - b).length()
	#print("Heuristic from", a, "to", b, ":", h)
	return h

func generate_road(start: Vector2i, end: Vector2i) -> void:
	print("Generating road from", start, "to", end)
	
	var open_set: Array = [start]
	var came_from: Dictionary = {}
	var g_score: Dictionary = {start: -75.-75}
	var f_score: Dictionary = {start: heuristic(start, end)}
	
	while open_set.size() > 0:
		# Sort open set by f_score (lowest first)
		open_set.sort_custom(func(a, b): return f_score.get(a, INF) < f_score.get(b, INF))
		var current: Vector2i = open_set.pop_front()
		#print("Processing node:", current)

		if current == end:
			print("Path found! Reconstructing path...")
			reconstruct_path(came_from, current)
			return
		
		# Explore neighbors
		for neighbor in get_neighbors(current):
			if not is_valid_tile(neighbor):
				print("Skipping invalid neighbor:", neighbor)
				continue  # Skip invalid tiles like lava
				
			var temp_g_score: float = g_score.get(current, INF) + current.distance_to(neighbor) + randf_range(0, 0.5)
			
			# If a better path is found, update scores
			if temp_g_score < g_score.get(neighbor, INF):
				came_from[neighbor] = current
				g_score[neighbor] = temp_g_score
				f_score[neighbor] = temp_g_score + heuristic(neighbor, end)

				if neighbor not in open_set:
					open_set.append(neighbor)

	print("No path found! Check if valid paths exist.")

func get_neighbors(pos: Vector2i) -> Array:
	var neighbors: Array = []
	
	# 8-directional movement
	var offsets = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
				   Vector2i(1, 1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1)]

	for offset in offsets:
		var new_pos = pos + offset
		if is_valid_tile(new_pos):  # Only add if it's valid
			neighbors.append(new_pos)

	#print("Neighbors for", pos, ":", neighbors)
	return neighbors

func reconstruct_path(came_from: Dictionary, current: Vector2i) -> void:
	print("Reconstructing path...")
	while current in came_from:
		#print("Path step:", current)
		place_road_tile(current)
		current = came_from[current]


var ROAD_WIDTH = 2  # Set the road width (2x2 tiles around the center)

func place_road_tile(pos: Vector2i) -> void:
	# Place multiple tiles around the current road tile
	for dx in range(-int(ROAD_WIDTH / 2), int(ROAD_WIDTH / 2) + 1):
		for dy in range(-int(ROAD_WIDTH / 2), int(ROAD_WIDTH / 2) + 1):
			var new_pos = pos + Vector2i(dx, dy)
			# Ensure the tile is within bounds and valid
			if is_valid_tile(new_pos):
				ground2_tiles_arr.append(new_pos)
				ground2_tilemaplayer.set_cell(Vector2i(new_pos.x, new_pos.y), road_id, road_atlas)
				#print("Placing road tile at:", new_pos)
