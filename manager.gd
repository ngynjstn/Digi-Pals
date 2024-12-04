extends Node2D

@export var battle_scene : PackedScene

var encounter_number : int = 100:
	set(value):
		encounter_number = value
		%Encounter.text = str(value)
		
func _ready():
	randomize()
	encounter_number = randi_range(25,50)
	load_ally_data()

var area : String = "Not"
var allyname : String = "000"
var player_last_position: Vector2 = Vector2(532,25)
 
var ally_cache : Dictionary = {}
@export_dir var ally_folder
 
func load_ally_data():
	var folder = DirAccess.open(ally_folder)
 
	folder.list_dir_begin()
	var file_name = folder.get_next()
 
	while file_name != "":
 
		ally_cache[file_name] = load(ally_folder + "/" + file_name)
 
		file_name = folder.get_next()
 
func get_ally(ID = "000") -> Ally:
	var ally_file_name = allyname + ".tres"
 
	return ally_cache[ally_file_name]

 

func change_scene():
	get_tree().change_scene_to_packed(battle_scene)
	encounter_number = randi_range(25,50)

func save_player_data(player):
	area = player.area
	player_last_position = player.position
 
