extends Node2D

@export var noise_height_text : NoiseTexture2D
var noise : Noise #Noise proc_gen_world
var width : int = 100
var height : int = 200
var source_id = 0 #Tilesetin id
var lava_atlas = Vector2i(0,8) #lavan kordinaatti tilesetissä
var land_atlas = Vector2i(0,0) #maan kordinaatti tilesetissä

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var lava_tilemaplayer: TileMapLayer = $TileMap/lava
@onready var ground_tilemaplayer: TileMapLayer = $TileMap/ground
@onready var ground_2_tilemaplayer: TileMapLayer = $TileMap/ground2

var ground_tiles_arr =[] 
var terrain_ground_int = 0 #Ground tilejen layer numero
var lava_tiles_arr =[]
var terrain_lava_int = 1 #Laavan layer numero

var noise_val_arr =[]

func _input(event): #zoom control, helpompi kattoa karttaa 
	if Input.is_action_just_pressed("zoomout"):
		var zoom_val = camera_2d.zoom.x - 0.1
		camera_2d.zoom = Vector2(zoom_val,zoom_val)
	if Input.is_action_just_pressed("zoomin"):
		var zoom_val = camera_2d.zoom.x + 0.1
		camera_2d.zoom = Vector2(zoom_val,zoom_val)

func _ready():
	noise = noise_height_text.noise
	generate_world()
	
func generate_world():
	#Käydään koko map läpi eli 100 x 200, josta tulee neljö isometric tilet on 32x16. -width/2,width/2 siirtää generoidun kartan keskelle
	for x in range(-width/2,width/2):
		for y in range(-height/2, height/2):
			var noise_val : float = noise.get_noise_2d(x,y)
			noise_val_arr.append(noise_val)
			
			#jos generoidun "äänen" arvo on <=-0.5 
			if noise_val <=-0.5:
				#place land
				ground_tiles_arr.append(Vector2i(x,y))
				ground_tilemaplayer.set_cell(Vector2i(x,y),source_id, land_atlas)
				
			elif noise_val > -0.5:
				#place lava
				lava_tiles_arr.append(Vector2i(x,y))
				lava_tilemaplayer.set_cell(Vector2i(x,y),source_id,lava_atlas)
	#testinä äänen korkein ja pienin arvo, eri kuvioilla on eri arvot niin pitää säätää elif noise_val > -0.5: if noise_val <=-0.5: sopiviksi
	print("korkein", noise_val_arr.max())
	print("pienin", noise_val_arr.min())
	
	ground_tilemaplayer.set_cells_terrain_connect(ground_tiles_arr,terrain_ground_int,0)
	lava_tilemaplayer.set_cells_terrain_connect(lava_tiles_arr,terrain_lava_int,0)
