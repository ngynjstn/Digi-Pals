extends Node2D

#@onready var animplayer = $AnimationPlayer
#@onready var camera = $Path2D/PathFollow2D/Cutscene2CAM
@onready var scream_player = $townmusic
@onready var starterscream = $AudioStreamPlayer2D
@onready var ryuki = $Ryuki
@onready var nevcorras = $Nevcorras
@onready var shenlong = $Shenlong

var is_bosscutscene = false
var has_player_entered_area = false
var player = null
#var is_pathfollowing = false

var smoke_has_happened = false
var smoke_is_happening = false

func _ready():
	ryuki.visible = true
	nevcorras.visible = true
	shenlong.visible = true
	print("Ready: Initializing second cutscene")
	

func _physics_process(delta):
	if is_bosscutscene:
		#var pathfollower = $cutscene/Path2D/PathFollow2D
		#if is_pathfollowing:
			#if not smoke_is_happening:
				#pathfollower.progress_ratio += 0.001
				#print("Path following: Progress ratio = ", pathfollower.progress_ratio)
			
			#if pathfollower.progress_ratio >= 1:
				cutsceneend()
				
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_invisible"):
		ryuki.visible = false
		nevcorras.visible = false
		shenlong.visible = false

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player = body
		if not has_player_entered_area:
			has_player_entered_area = true
			print("Player detected: Starting second cutscene")
			cutsceneopen()
			
func _on_starter_detection_body_entered(body: Node2D) -> void:
	if starterscream:
		starterscream.play()


func cutsceneopen():
	is_bosscutscene = true
	#animplayer.play("cover_fade")
	#is_pathfollowing = true
	scream_player.play()
	print("Second cutscene opening: Camera switched")

func cutsceneend():
	#is_pathfollowing = false
	is_bosscutscene = false
	#$cutscene.visible = false
	print("Second cutscene ending: Camera switched back")
