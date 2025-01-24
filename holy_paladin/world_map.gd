extends Node2D
#Tätä hommaa ajetaan seuraavalla tavalla:
#Proc_world_gen nodessa on noise ominaisuus, mapin ulkonäköä voi muuttaa vaihtamalla noise ja color ramp asetuksia.
#Noise osiossa voi vaihtaa millä "ääni" mallilla godot luo kartan, kannattaa pitää celullar generointi päällä.
# Vaihtamalla "seed" arvoa voi vaihtaa tämänhetkisten asetusten pohjalta eri mappeja.
#jos vaihtaa cellular:ista johonkin toiseen kannattaa katsoa min ja max printit ja vaihtaa generate_world() kohtaan
# sopivat arvot if-lauseisiin
@export var noise_height_text : NoiseTexture2D
var noise : Noise #Noise proc_world_gen
var width : int = 100
var height : int = 200
var source_id = 0 #Tilesetin id
var lava_atlas = Vector2i(0,8) #lavan kordinaatti tilesetissä
var land_atlas = Vector2i(1,0) #maan kordinaatti tilesetissä
var rocks_atlas = Vector2i(0,5)

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var ground_tilemaplayer: TileMapLayer = $ground
@onready var rocks_tilemaplayer: TileMapLayer = $ground2
@onready var lava_tilemaplayer: TileMapLayer = $lava
@onready var environment_tilemaplayer: TileMapLayer = $environment



var ground_tiles_arr =[] 
var terrain_ground_int = 0 #Ground tilejen layer numero
var lava_tiles_arr =[]
var terrain_lava_int = 1 #Laavan layer numero
var rocks_tiles_arr =[]
var terrain_rocks_int = 2

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
	#Käydään koko map läpi eli 100 x 200, josta tulee neljä isometric tilet on 32x16. -width/2,width/2 siirtää generoidun kartan keskelle
	for x in range(-width/2,width/2):
		for y in range(-height/2, height/2):
			var noise_val : float = noise.get_noise_2d(x,y)
			noise_val_arr.append(noise_val)
			
			#jos generoidun "äänen" arvo on <=-0.5 
			if noise_val <=-0.50:
				#place rock
				if noise_val > -0.7  and noise_val <-0.84:
					rocks_tiles_arr.append(Vector2i(x,y))
					rocks_tilemaplayer.set_cell(Vector2i(x,y),source_id,rocks_atlas)
				#place land
				ground_tiles_arr.append(Vector2i(x,y))
				ground_tilemaplayer.set_cell(Vector2i(x,y),source_id, land_atlas)
				
			if noise_val >= -0.50:
				#place lava
				lava_tiles_arr.append(Vector2i(x,y))
				lava_tilemaplayer.set_cell(Vector2i(x,y),source_id,lava_atlas)
			
				
	#testinä äänen korkein ja pienin arvo, eri kuvioilla on eri arvot niin pitää säätää elif noise_val > -0.5: if noise_val <=-0.5: sopiviksi
	print("korkein", noise_val_arr.max())
	print("pienin", noise_val_arr.min())
	
	ground_tilemaplayer.set_cells_terrain_connect(ground_tiles_arr,terrain_ground_int,0)
	lava_tilemaplayer.set_cells_terrain_connect(lava_tiles_arr,terrain_lava_int,0)
	rocks_tilemaplayer.set_cells_terrain_connect(rocks_tiles_arr,terrain_rocks_int,0)
