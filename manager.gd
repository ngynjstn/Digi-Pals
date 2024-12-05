extends Node2D

@export var greenbattle_scene : PackedScene
@export var redbattle_scene : PackedScene
@export var purplebattle_scene : PackedScene

var encounter_number : int = 100:
	set(value):
		encounter_number = value
		%Encounter.text = str(value)
		
func _ready():
	randomize()
	encounter_number = randi_range(25,50)

var area : String = "Not"
var player_last_position: Vector2 = Vector2(532,10)
 
var pal : String = "Non"
var saved_pal: String = ""

func save_player_pal(pal: String):
	saved_pal = pal
	print("Pal saved:", saved_pal)

func load_player_pal() -> String:
	return saved_pal
func change_scenegreen():
	get_tree().change_scene_to_packed(greenbattle_scene)
	encounter_number = randi_range(25,50)
	
func change_scenered():
	get_tree().change_scene_to_packed(redbattle_scene)
	encounter_number = randi_range(25,50)

func change_scenepurple():
	get_tree().change_scene_to_packed(purplebattle_scene)
	encounter_number = randi_range(25,50)

func save_player_data(player):
	area = player.area
	player_last_position = player.position
 
