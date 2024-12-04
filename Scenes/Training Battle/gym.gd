extends Node2D

@onready var animplayer = $cutscene/AnimationPlayer
@onready var camera = $cutscene/Path2D/PathFollow2D/Cutscene1CAM
@onready var scream_player = $cutscene/AudioStreamPlayer2D

var is_bosscutscene = false
var has_player_entered_area = false
var player = null
var is_pathfollowing = false

var smoke_has_happened = false
var smoke_is_happening = false

func _ready():
	print("Ready: Initializing first cutscene")
	scream_player.play()

func _physics_process(delta):
	if is_bosscutscene:
		var pathfollower = $cutscene/Path2D/PathFollow2D
		if is_pathfollowing:
			if not smoke_is_happening:
				pathfollower.progress_ratio += 0.001
				print("Path following: Progress ratio = ", pathfollower.progress_ratio)
			
			if pathfollower.progress_ratio >= 1:
				cutsceneending()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player = body
		if not has_player_entered_area:
			has_player_entered_area = true
			print("Player detected: Starting first cutscene")
			cutsceneopening()

func cutsceneopening():
	is_bosscutscene = true
	animplayer.play("cover_fade")
	player.get_node("MainCAM").enabled = false
	camera.enabled = true
	is_pathfollowing = true
	print("First cutscene opening: Camera switched")

func cutsceneending():
	is_pathfollowing = false
	is_bosscutscene = false
	camera.enabled = false
	player.get_node("MainCAM").enabled = true
	$cutscene.visible = false
	print("First cutscene ending: Camera switched back")
