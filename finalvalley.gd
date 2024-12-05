extends Node2D

@onready var animplayer = $cutscene/AnimationPlayer
@onready var camera = $cutscene/Path2D/PathFollow2D/Camera2D
@onready var forest2_node = $forest2
@onready var boss = $Boss/Sprite2D
@onready var girlfriend = $Girlfriend
@onready var smoke = $cutscene/smokeparticles1
@onready var scream_player = $Boss/AudioStreamPlayer2D
@onready var dialogue_label = $Dialouge/Label  # Reference to the Label node for dialogue
@onready var dialogue = $Dialouge
@onready var mainplayer = $Player

var is_bosscutscene = false
var has_player_entered_area = false
var player = null
var is_pathfollowing = false

var smoke_has_happened = false
var smoke_is_happening = false

var dialogues = [
	"Well Well Well... Took you long enough",
	"I am going to get you!"
]

var current_dialogue_index = 0

func _ready():
	mainplayer.position = Vector2(128, 16)
	dialogue_label.visible = false  # Hide dialogue initially
	dialogue.visible = false

func _physics_process(delta):
	if is_bosscutscene:
		var pathfollower = $cutscene/Path2D/PathFollow2D
		if is_pathfollowing:
			if not smoke_is_happening:
				pathfollower.progress_ratio += 0.001
			
			if pathfollower.progress_ratio >= 1:
				cutsceneending()
				
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player = body
		if not has_player_entered_area:
			has_player_entered_area = true
			cutsceneopening()

func cutsceneopening():
	is_bosscutscene = true
	player.get_node("Camera2D").enabled = false
	camera.enabled = true
	is_pathfollowing = true

func cutsceneending():
	is_pathfollowing = false
	is_bosscutscene = false
	camera.enabled = false
	player.get_node("Camera2D").enabled = true
	$cutscene.visible = false
	start_inner_dialogue()
	
func start_inner_dialogue():
	dialogue.visible = true
	dialogue_label.visible = true
	show_next_dialogue()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		show_next_dialogue()
		
func show_next_dialogue():
	if current_dialogue_index < dialogues.size():
		dialogue_label.text = dialogues[current_dialogue_index]
		current_dialogue_index += 1
	else:
		dialogue_label.visible = false  # Hide dialogue after all lines are shown
		dialogue.visible = false
