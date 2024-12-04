extends Node2D

@onready var animplayer = $AnimationPlayer
@onready var camera = $Path2D/PathFollow2D/Cutscene2CAM
@onready var scream_player = $townmusic

var is_bosscutscene = false
var has_player_entered_area = false
var player = null
var is_pathfollowing = false

var smoke_has_happened = false
var smoke_is_happening = false

func _ready():
	print("Ready: Initializing second cutscene")
	scream_player.play()

func _physics_process(delta):
	if is_bosscutscene:
		var pathfollower = $cutscene/Path2D/PathFollow2D
		if is_pathfollowing:
			if not smoke_is_happening:
				pathfollower.progress_ratio += 0.001
				print("Path following: Progress ratio = ", pathfollower.progress_ratio)
			
			if pathfollower.progress_ratio >= 1:
				cutsceneend()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player = body
		if not has_player_entered_area:
			has_player_entered_area = true
			print("Player detected: Starting second cutscene")
			cutsceneopen()

func cutsceneopen():
	is_bosscutscene = true
	animplayer.play("cover_fade")
	Global.set_active_camera(camera)
	is_pathfollowing = true
	print("Second cutscene opening: Camera switched")

func cutsceneend():
	is_pathfollowing = false
	is_bosscutscene = false
	Global.set_active_camera(player.get_node("MainCAM"))
	$cutscene.visible = false
	print("Second cutscene ending: Camera switched back")
