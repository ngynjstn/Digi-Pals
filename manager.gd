extends Node2D

@export var battle_scene : PackedScene

var encounter_number : int = 100:
	set(value):
		encounter_number = value
		%Encounter.text = str(value)
		
func _ready():
	randomize()
	encounter_number = randi_range(25,50)

var area : String = "Not"
var player_last_position: Vector2 = Vector2(532,25)
 

func change_scene():
	get_tree().change_scene_to_packed(battle_scene)
	encounter_number = randi_range(25,50)

func save_player_data(player):
	area = player.area
	player_last_position = player.position
 
